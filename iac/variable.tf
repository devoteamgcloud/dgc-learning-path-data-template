### GLOBAL ###
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


### TABLES SCHEMAS ###
### Raw ####
variable "raw_basket_schema_path" {
  description = "Path to the raw_basket table schema file."
  default     = "../schemas/raw/basket.json"
}

variable "raw_customer_schema_path" {
  description = "Path to the raw_customer table schema file."
  default     = "../schemas/raw/customer.json"
}

variable "raw_store_schema_path" {
  description = "Path to the raw_store table schema file."
  default     = "../schemas/raw/store.json"
}

### Staging ###
variable "staging_customer_schema_path" {
  description = "Path to the staging_customer table schema file."
  default = "../schemas/staging/customer.json"
}

variable "staging_basket_schema_path" {
  description = "Path to the staging_basket table schema file."
  default = "../schemas/staging/basket.json"
}

variable "staging_basket_detail_schema_path" {
  description = "Path to the staging_basket_detail table schema file."
  default = "../schemas/staging/basket_detail.json"
}

### Cleaned ###
variable "cleaned_store_schema_path" {
  description = "Path to the cleaned table schema file."
  default     = "../schemas/cleaned/store.json"
}

variable "cleaned_customer_schema_path" {
  description = "Path to the cleaned_customer table schema file."
  default     = "../schemas/cleaned/customer.json"
}

variable "cleaned_basket_header_schema_path" {
  description = "Path to the basket_header table schema file."
  default     = "../schemas/cleaned/basket_header.json"
}

variable "cleaned_basket_detail_schema_path" {
  description = "Path to the basket_header table schema file."
  default     = "../schemas/cleaned/basket_detail.json"
}

### Aggregated ###
variable "open_store_schema_path" {
  description = "Path to the open_store table schema file."
  default     = "../schemas/aggregated/open_store.json"
}

variable "customer_purchase_schema_path" {
  description = "Path to the customer_purchase table schema file."
  default     = "../schemas/aggregated/customer_purchase.json"
}

variable "day_sale_header_schema_path" {
  description = "Path to the day_sale table schema file."
  default     = "../schemas/aggregated/day_sale_header.json"
}

variable "best_product_sale_schema_path" {
  description = "Path to the best_product_sale table schema file."
  default     = "../schemas/aggregated/best_product_sale.json"
}