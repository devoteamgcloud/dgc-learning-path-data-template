resource "google_cloud_run_service" "trigger_on_file" {
  name     = "trigger-on-file-cloud-run"
  location = "europe-west1"

  project  = var.project_id
  template {
      spec{
        containers {
          image = "eu.gcr.io/sandbox-vcordonnier/test:0.2"  
        }
      }
    
  }
}