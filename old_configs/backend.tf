terraform {
  backend "s3" {
    bucket = "nehm-networking-bucket-demo"
    key    = "eip.tfstate"
    region = "us-east-1"
  }
}
