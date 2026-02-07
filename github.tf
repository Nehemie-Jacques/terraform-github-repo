terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Le token GitHub doit être configuré via la variable d'environnement:
# export GITHUB_TOKEN="votre_nouveau_token"
provider "github" {
  # token est automatiquement lu depuis la variable d'environnement GITHUB_TOKEN
}

resource "github_repository" "example" {
  name        = "terraform-github-repo"
  description = "A repository created with Terraform"
  visibility  = "public"
}
