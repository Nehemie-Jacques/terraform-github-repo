variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "production"
}

variable "region" {
  description = "The AWS region for the resources"
  type        = string
  default     = "us-west-2"
}

resource "aws_instance" "myec2" {
    ami = "ami-00c39f71452c08778"
    instance_type = var.environment == "production" ? "m5.large" : "t3.micro"
}

resource "aws_instance" "myec2" {
    ami = "ami-00c39f71452c08778"
    instance_type = var.environment != "production" ? "m5.large" : "t3.micro"
}

resource "aws_instance" "myec2" {
    ami = "ami-00c39f71452c08778"
    instance_type = var.environment != "production" && var.region != "us-west-2" ? "m5.large" : "t3.micro"
}

resource "aws_instance" "myec2" {
    ami = "ami-00c39f71452c08778"
    instance_type = var.environment == "production" && var.region == "us-west-2" ? "m5.large" : "t3.micro"
}