provider "aws" {
  region = "${var.region}"
}

data "aws_iam_policy_document" "s3-bucket-access" {
  // Allow list action to the particular bucket
  statement {
    sid = "ReadBucket"
    actions = [
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::venafi-sdk-secrets"]
  }

  statement {
    sid = "AllObjectActions"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::venafi-sdk-secrets/*"]
  }
}

resource "aws_iam_role" "venafi-grant-s3-bucket-access" {
  name               = "venafi-grant-s3-bucket-access"
  assume_role_policy = "${file("./role_policy.json")}"

  tags = {
    Name = "venafi-grant-s3-bucket-access"
  }
}

resource "aws_iam_role_policy" "iam-role" {
  name   = "s3-bucket-access-policy"
  role   = "${aws_iam_role.venafi-grant-s3-bucket-access.id}"
  policy = "${data.aws_iam_policy_document.s3-bucket-access.json}"
}

// Create an instance profile and drop the IAM role into it
resource "aws_iam_instance_profile" "venafi-webserver-instance-profile" {
  name = "venafi-webserver-instance-profile"
  role = "${aws_iam_role.venafi-grant-s3-bucket-access.name}"
}

resource "aws_security_group" "venafi" {
  name        = "venafi-web-sg"
  description = "Control the traffic for the apache server managed by venafi"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.ssh_ip_addrs}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "apache" {
  key_name   = "apache"
  public_key = "${file("/home/venkat/.ssh/aws-temp.pub")}"
}

resource "aws_instance" "venafi-apache-test-server" {
  ami                    = "${var.lnx-ami}"
  instance_type          = "${var.instance-type}"
  key_name               = "${aws_key_pair.apache.key_name}"
  vpc_security_group_ids = ["${aws_security_group.venafi.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.venafi-webserver-instance-profile.name}"
  user_data              = "${file("user-data.sh")}"

  tags = {
    Name = "venafi-apache-test-server"
  }
}
