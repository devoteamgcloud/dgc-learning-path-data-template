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
    raw = [
      {
        tables_name = "store",
        schema      = "../schemas/raw/store.json"
      }
    ],
    cleaned = [
      {
        tables_name = "store",
        schema      = "../schemas/cleaned/store.json"
      }
    ]
  }
}
variable "bq_datasets" {
  type    = list(string)
  default = ["raw", "cleaned"]
}

variable "bq_tables" {
  type = list(map(any))
  default = [
    {
      tables_name = "store",
      datasets = [
        { dataset_id = "raw",
          schema     = "../schemas/raw/store.json"
        },
        { dataset_id = "cleaned",
          schema     = "../schemas/cleaned/store.json"
        }
      ]
    }
  ]

}
