resource "aws_security_group" "payment_app" {
  name        = "payment_app"
  description = "Application Security Group"
  depends_on  = [aws_eip.example]

  # Below ingress allows HTTPS  from DEV VPC

  ingress {
    description = "Allow HTTPS from DEV VPC"
    from_port   = var.HTTPS
    to_port     = var.HTTPS
    protocol    = "tcp"
    cidr_blocks = [var.dev_vpc_cidr]
  }

  # Below ingress allows APIs access from DEV VPC

  ingress {
    description = "Allow APIs from DEV VPC"
    from_port   = var.APIs_DEV
    to_port     = var.APIs_DEV
    protocol    = "tcp"
    cidr_blocks = [var.dev_vpc_cidr]
  }

  # Below ingress allows APIs access from Prod App Public IP.

  ingress {
    description = "Allow APIs from Prod App Public IP"
    from_port   = var.APIs_PROD
    to_port     = var.APIs_PROD
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.example.public_ip}/32"]
  }


  egress {
    description = "Allow traffic to Splunk"
    from_port   = var.splunk
    to_port     = var.splunk
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "payment_app"
    team = "payment"
    Environment = "dev"
  }

}