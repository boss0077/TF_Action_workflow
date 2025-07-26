terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "trfm-bkend"  #s3 bucket name 
    key = "terraform.tfstate"  #path within the bucket(oobject key)
    region = "us-east-1"
    dynamodb_table = "state-lock"
    encrypt = true
  } 
}

 provider "aws" {
    region = "us-east-1"
} 

resource "aws_security_group" "ssh_sg" {
  name        = "ssh_access_sg"
  description = "Allow SSH inbound"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP for security, e.g., ["203.0.113.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh_access_sg"
  }
}



module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name = "local-server"
  instance_type = "t3.small"
  key_name = "jul25"
  subnet_id = "subnet-0bedad30cda514afd"

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  touch sudarshan
  echo "Hello, World!" > /home/ec2-user/sudarshan
  chown ec2-user:ec2-user /home/ec2-user/sudarshan
  EOF 

  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Environment = "test"
  }
}

