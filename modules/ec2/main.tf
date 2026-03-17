terraform {
  required_providers {
    mycloud = {
      source  = "haschicorp/aws"
      version = "~> 1.0"
    }
  }
}


provider "aws" {
  region = var.region
}

resource "aws_instance" "myec2" {
    ami = var.ami
    instance_type = var.instance_type
}

variable "region" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}