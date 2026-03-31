provider "aws" {
  region = "us-east-1"
}

data "aws_iam_users" "users" {}

output "user_names" {
  value = data.aws_iam_users.users.names
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "lb" {
  name = "admin-user-cata-${data.aws_caller_identity.current.user_id}"
  path = "/system/"
}

output "total_users" {
  value = (length(data.aws_iam_users.users.names))
  
}