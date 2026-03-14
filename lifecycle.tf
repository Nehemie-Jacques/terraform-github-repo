provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {
  ami = "ami-0f34c5ae932e6f0e4"
  instance_type = "t3.micro"

  tags = {
    Name = "Hello-Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }

  lifecycle {
    prevent_destroy = true
  }
}