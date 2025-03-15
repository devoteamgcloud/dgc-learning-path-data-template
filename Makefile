.PHONY: format
format: ## Format the python code of the cloud functions using isort and ruff
	@echo "Formatting code..."
	isort cloud_functions
	ruff format cloud_functions

.PHONY: init
init: ## Initialize Terraform in iac directory
	@cd iac && \
	terraform init -input=false -upgrade -backend-config=init/backend.tfvars

.PHONY: plan
plan: ## Plan the terraform changes in iac directory
	@cd iac && \
	terraform plan -out changes.tfplan -var project_id=sandbox-jrubin

.PHONY: apply
apply: ## Apply the terraform changes in iac directory
	@cd iac && \
	terraform apply -input=false -no-color -auto-approve changes.tfplan

.PHONY: help
help: ## Print all available make commands.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
