variable "splunk" {
  type    = number
}

variable "dev_vpc_cidr" {
  default = "172.31.0.0/16"
  type    = string
}

variable "APIs_DEV" {
  default = 8080
  type    = number
}

variable "APIs_PROD" {
  default = 8443
  type    = number
}

variable "HTTPS" {
  default = 443
  type    = number
}