terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}


provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "vault" {
  # address = "http://localhost:8200"  # Ersetzen Sie dies durch die URL Ihres Vault-Servers
}