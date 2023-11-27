terraform {
  required_version = ">= 0.15"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"
    }
  }
  backend "gcs" {
    bucket = "sandbox-vvaneecloo-gcs-tfstate-sbx"
    prefix = "terraform-states"
  }
}

provider "google" {
  project = "sandbox-vvaneecloo"
  region  = "europe-west3"
}