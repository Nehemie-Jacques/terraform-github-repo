terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}


# ===== Exemples simples =====

# Exemple AWS : créer une instance EC2
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "example-instance"
  }
}

# Exemple Azure : créer un resource group
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

# Exemple GCP : créer une bucket de stockage
resource "google_storage_bucket" "example" {
  name          = "my-example-bucket"
  location      = "US"
  force_destroy = true
}


# ===== AWS Provider =====
provider "aws" {
  region = "us-east-1"
  # Les credentials sont lus depuis :
  # - Variables d'environnement: AWS_ACCESS_KEY_ID et AWS_SECRET_ACCESS_KEY
  # - Fichier ~/.aws/credentials
  # - IAM role (si sur EC2)
}

# ===== Azure Provider =====
provider "azurerm" {
  features {}
  # Les credentials sont lus depuis :
  # - Variables d'environnement: ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
  # - az login (Azure CLI)
  skip_provider_registration = false
}

# ===== Google Cloud Platform Provider =====
provider "google" {
  project = "my-gcp-project"  # Remplacer par votre projet GCP
  region  = "us-central1"
  # Les credentials sont lus depuis :
  # - Variables d'environnement: GOOGLE_APPLICATION_CREDENTIALS (chemin vers le fichier JSON)
  # - gcloud auth application-default login
}
