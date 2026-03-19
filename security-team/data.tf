data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    bucket = "nehm-networking-bucket-demo"
    key    = "eip.tfstate"
    region = "us-east-1"
  }
}
