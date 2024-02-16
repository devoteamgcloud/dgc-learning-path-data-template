variable "project_id" {
  type        = string
  description = "Project identifier"
  default     = "dgc-data-plp-pd"
}

variable "location" {
  description = "GCP location"
  type        = string
  default     = "EU"
}

variable "pubsub_topic_id" {
  description = "GCP location"
  type        = string
  default     = "valid_file"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "bq_datasets_setting" {
  default = {
    raw = {
      tables_name = "store",
      schema      = "../schemas/raw/store.json"
    },
    cleaned = {
      tables_name = "store",
      schema      = "../schemas/cleaned/store.json"
    }
  }
}
