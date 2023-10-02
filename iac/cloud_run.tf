resource "google_cloud_run_v2_service" "trigger-on-file" {
  name     = "trigger-on-file-cloud-run"
  location = "europe-west1"

  project  = var.project_id
  template {
    containers {
      image = "docker.io/library/trigger-on-file"  
    }
  }
}