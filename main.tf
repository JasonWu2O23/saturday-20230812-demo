terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

    backend "s3" {
        bucket = "sctp-ce3-tfstate-bucket"
        key = "jinqing.tfstate"
        region = "us-east-1"
    }

}

resource "aws_security_group" "jinqing_allow_http_https_ssh_traffic" {
  name        = "jinqing_allow_http_https_ssh_traffic"
  description = "Allow inbound traffic for https, http and ssh"

  ingress {
    description      = "HTTPS inbound"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP inbound"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH inbound"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Equivalent to all
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}