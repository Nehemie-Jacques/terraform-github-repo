provider "aws" {
  region     = "us-east-1"
}

import {
  to = aws_security_group.mysg
  id = "sg-0cb1d24f89a61a328"
}