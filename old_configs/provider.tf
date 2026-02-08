provider "aws" {
  region = "us-east-1"
  # Les credentials seront pris depuis:
  # 1. Variables d'environnement AWS_ACCESS_KEY_ID et AWS_SECRET_ACCESS_KEY
  # 2. Fichier ~/.aws/credentials
  # 3. IAM role si vous êtes sur EC2
}
