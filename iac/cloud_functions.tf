variable "project_id" {
    default = "sandbox-lhanot"
}
variable "region" {
    default = "europe-west1"
}
provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_storage_bucket" "magasin_cie_landing" {
  project  = var.project_id
  name     = "${var.project_id}_magasin_cie_landing"
  location = var.location
}