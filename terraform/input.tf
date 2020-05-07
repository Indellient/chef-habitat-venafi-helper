variable "region" {
    type = "string"
    default = "us-east-1"
}

variable "lnx-ami" {
    type = "string"
}

variable "instance-type" {
    type = "string"
}

variable "ssh_ip_addrs" {
    type = "list"
}