terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }

  required_version = ">= 0.14.9"
}

provider "google" {
  project = "primal-seeker-290111"
  region  = "us-east1"
  zone    = "us-east1-b"

}