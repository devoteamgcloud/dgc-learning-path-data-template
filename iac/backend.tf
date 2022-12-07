terraform {
  required_version = ">= 0.15"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"
    }
  }
  backend "gcs" {
    bucket = "sandbox-ymarcel-gcs-tfstate-sbx"
    prefix = "terraform-states"
  }
}