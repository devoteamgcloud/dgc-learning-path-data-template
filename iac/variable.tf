variable "project_id" {
 type        = string
 description = "Project identifier"
  default = "sandbox-cselmene"
}

variable "location"{
 description = "GCP location"
 type = string
 default = "EU"
}

variable "pubsub_topic_id"{
 description = "GCP location"
 type = string
 default = "valid_file"
}

variable "region"{
 description = "GCP region"
 type = string
 default = "europe-west1"
}
locals {
  all_files   = fileset(path.module, "../{queries,schemas}/**")
}