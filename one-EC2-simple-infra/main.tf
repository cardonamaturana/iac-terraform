provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
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


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.ssh_key_path)
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "Allow HTTPS outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  # Regla de salida HTTPS para permitir tráfico saliente
  egress {
    description = "HTTPS to anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de salida por defecto (permite todoo el tráfico saliente)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_https"
  }
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  # Regla de entrada para HTTP (puerto 80)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de salida por defecto (permite todoo el tráfico saliente)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }


}
locals {
  extra_tag = "reto-backend-aws-pragma"
}

resource "aws_instance" "reto-backend-pragma-java" {
  for_each               = var.instances_names
  ami                    = data.aws_ami.ubuntu_20_04.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id, aws_security_group.allow_https.id,
    aws_security_group.allow_http.id
  ]
  user_data              = var.initial_script_instance


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