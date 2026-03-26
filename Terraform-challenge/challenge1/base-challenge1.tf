terraform {
  required_version = ">= 0.12.31"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.54"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "digitalocean" {}

resource "aws_eip" "kplabs_app_ip" {
  domain = "vpc"
}