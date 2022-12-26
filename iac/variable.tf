variable "project_id" {
  type        = string
  description = "Project identifier"
  # default = "sandbox-nbrami"
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

# variable "bucket_name" {
#   type = string
#   description = "Bucket name"
# }
# variable "storage_class" {
#   type = string

# }

variable "bucket_location" {
  type = string
  default = "us-east1"
}

variable "python_code_location" {
  type = string
  default = "../cloud_functions/cf_trigger_on_file/src"
}

variable "cleaned_store_sql" {
  type = string
  default = "../queries/cleaned/store.sql"
}
variable "raw_store_json" {
  type = string
  default = "../schemas/raw/store.json"
}
variable "cleaned_store_json" {
  type = string
  default = "../schemas/cleaned/store.json"
}
