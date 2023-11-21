variable "project_id" {
  type        = string
  description = "Project identifier"
  default     = "sandbox-vvaneecloo"
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

variable "cleaned_schema_path" {
  description = "Path to the cleaned schema file."
  default     = "../schemas/cleaned/store.json"
}

variable "raw_schema_path" {
  description = "Path to the raw schema file."
  default     = "../schemas/raw/store.json"
}