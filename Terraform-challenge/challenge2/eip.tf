resource "aws_eip" "example" {
  domain = "vpc"

  tags = {
    name = "payment_app"
    team = "payment"
    Environment = "dev"
  }
}
