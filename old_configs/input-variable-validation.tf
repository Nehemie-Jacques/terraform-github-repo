variable "db_password" {
  type = string
  description = "The password for the database"

  validation {
    condition = length(var.db_password) >= 12
    error_message = "The database password must be at least 12 characters long."
  }
}