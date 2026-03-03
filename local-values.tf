variable "tags" {
  type = map
  default = {
    Team = "Security-team"
  }
}

locals {
    default = {
        Team = "Security-local"
        CreationDate = "date-${formatdate("DD MMM YYYY hh:mm ZZZ",timestamp())}"
    }
}

resource "aws_security_group" "sg_01" {
    name = "app_firewall"
    description = "Security group for app firewall"
    tags = local.default
}

resource "aws_security_group" "sg_02" {
    name = "db_firewall"
    description = "Security group for db firewall"
    tags = local.default
}