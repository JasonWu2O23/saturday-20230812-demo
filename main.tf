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

resource "aws_instance" "Jinqing-WebServer-1" {
  ami = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"
  key_name = "JinqingKeyPair"
  associate_public_ip_address = "true"
  subnet_id = "subnet-027c8f2bf5bd91bd8"
  vpc_security_group_ids = [aws_security_group.jinqing_allow_https_ssh_icmp_traffic.id]

  tags = {
    Name = "Jinqing-WebServer-1"
  }
}

resource "aws_instance" "Jinqing-WebServer-2" {
  ami = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"
  key_name = "JinqingKeyPair"
  associate_public_ip_address = "true"
  subnet_id = "subnet-027c8f2bf5bd91bd8"
  vpc_security_group_ids = [aws_security_group.jinqing_allow_https_ssh_icmp_traffic.id]

  tags = {
    Name = "Jinqing-WebServer-2"
  }
}

resource "aws_instance" "Jinqing-Ansibleserver" {
  ami = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"
  key_name = "JinqingKeyPair"
  associate_public_ip_address = "true"
  subnet_id = "subnet-027c8f2bf5bd91bd8"
  vpc_security_group_ids = [aws_security_group.jinqing_allow_https_ssh_icmp_traffic.id]
  user_data = file("${path.module}/ec2-user-data.sh") 

  tags = {
    Name = "Jinqing-Ansibleserver"
  }
}

resource "aws_security_group" "jinqing_allow_https_ssh_icmp_traffic" {
  name        = "jinqing_allow_https_ssh_icmp_traffic"
  description = "Allow inbound traffic for https, ssh and icmp"

  ingress {
    description      = "HTTPS inbound"
    from_port        = 443
    to_port          = 443
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

    ingress {
    description      = "ICMP inbound"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
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