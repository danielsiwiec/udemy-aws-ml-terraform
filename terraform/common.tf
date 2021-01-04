provider "aws" {
  region = "us-west-2"
}

variable "common_tags" {
  type = map(string)
}

variable "my_ip" {
  type = string
}

resource "aws_key_pair" "public-key" {
  key_name   = "public-key"
  public_key = file("~/.ssh/id_rsa.pub")

  tags = var.common_tags
}