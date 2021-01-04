data "aws_ami" "aws_deep_learning" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Deep Learning AMI*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["898082745236"]
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "private_inbound" {
  name        = "private_inbound"
  description = "Allow my IP address only"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "My IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.aws_deep_learning.id
  instance_type = "p3.2xlarge"
  vpc_security_group_ids = [ aws_security_group.private_inbound.id ]
  key_name = var.key_name

  tags = var.tags
}