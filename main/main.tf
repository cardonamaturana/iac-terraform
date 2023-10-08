terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}



provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key

  secret_key = var.secret_key
}


data "aws_ami" "ubuntu_20_04" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Este es el ID de Canonical (propietario de las AMIs de Ubuntu)
}

locals {
  extra_tag = "reto-backend-aws-pragma"
}

resource "aws_instance" "reto-backend-pragma-java" {
  for_each      = var.instances_names
  ami           = data.aws_ami.ubuntu_20_04.id
  instance_type = "t2.micro"


  tags = {
    Extra_Tag = local.extra_tag
    Name      = "EC2-${each.key}"
  }

}


resource "aws_cloudwatch_log_group" "ec2_log_group" {
  for_each = var.instances_names
  tags = {
    Environment = "test"
    Service     = each.key
  }
  lifecycle {
    create_before_destroy = true
  }
}