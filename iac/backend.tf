terraform {
  required_version = ">= 0.15"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"
    }
  }
  terraform {
  backend "local" {}
}
    #backend "gcs" {
    #bucket = "${var.project_id}-gcs-tfstate-sbx"
    #prefix = "terraform-states" }
}



