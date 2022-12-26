terraform {
  required_version = ">= 0.15"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"

    }
    # TODO montrer a qlqun et est ce que il y a path project comme le python path
    # project  = "sandbox-nbrami"


  }
  backend "gcs" {
    bucket = "sandbox-nbrami-gcs-tfstate-sbx"
    prefix = "terraform-states"
  }
}

