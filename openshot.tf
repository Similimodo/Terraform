provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_security_group" "ubuntu_http_ssh" {
  name        = "ubuntu_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"


  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Paschal Onor"
  }
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu_ami.id}"
  instance_type = "c5.xlarge"
  security_groups = ["${aws_security_group.ubuntu_http_ssh.name}"]
  key_name = "paschalonor"

  tags = {
    Name = "Paschal Onor"
  }
}

output "IP" {
  value = "${aws_instance.web.public_ip}"
}