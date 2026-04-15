output "user_arn" {
  description = "ARN de l'utilisateur créé"
  value       = aws_iam_user.s3_user.arn
}

output "user_login_url" {
  description = "Lien de connexion AWS Console"
  value       = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
}

data "aws_caller_identity" "current" {}

output "user_initial_password" {
  description = "Mot de passe initial (A CHANGER À LA PREMIÈRE CONNEXION)"
  value       = aws_iam_user_login_profile.s3_user_profile.password
  sensitive   = true
}