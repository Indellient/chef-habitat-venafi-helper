output "ec2-public-dns" {
    value = "${aws_instance.venafi-apache-test-server.public_dns}"
}