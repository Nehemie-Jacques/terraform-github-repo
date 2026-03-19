resource "aws_instance" "myec2" {
  ami = "ami-0c0100f1a4084f189"
  instance_type = "t2.micro"
}

output "instance_id" {
  value = aws_instance.myec2.id
}





# resource "aws_instance" "myec2" {
#     ami = var.ami
#     instance_type = var.instance_type
# }

# terraform {
#   required_providers {
#     awsmycloud = {
#       source  = "haschicorp/aws"
#       version = "~> 5.50"
#     }
#   }
# }

# variable "region" {
#   type = string
# }

# variable "ami" {
#   type = string
# }

# variable "instance_type" {
#   type = string
# }