terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
        configuration_aliases = [aws.prod]
    }
  }
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "My security group"
}

resource "aws_security_group" "prod" {
  name        = "prod-security-group"
  description = "Production security group"
  provider = aws.prod
}