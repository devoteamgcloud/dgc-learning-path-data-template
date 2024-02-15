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
variable "dataset_setting" {
  default = ["raw", "cleaned"]
}

variable "table_setting" {
  default = {
    "store" = [{ dataset_id = "cleaned", schema = "../schemas/cleaned/store.json" },
      { dataset_id = "raw", schema = "../schemas/raw/store.json" }
    ]
  }
}
