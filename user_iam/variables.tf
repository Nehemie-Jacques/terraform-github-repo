variable "user_name" {
  description = "Nom de l'utilisateur IAM"
  type        = string
  default     = "s3-manager-user"
}

variable "user_email" {
  description = "Email de l'utilisateur pour recevoir les alertes budget"
  type        = string
  default     = "votre-email@example.com"
}

variable "budget_limit" {
  description = "Limite du budget en USD (ex: 3$)"
  type        = string
  default     = "3.0"
}

variable "region_restriction" {
  description = "Région autorisée pour la création des buckets S3"
  type        = string
  default     = "eu-west-3"
}