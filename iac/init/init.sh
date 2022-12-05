# Small script to initialize ressources before being able to use Terraform.
# PROJECT_ID=sandbox-$1
# we must to pass the project_id as a variable at the moment of the execution of the script. 
# in Terraform with cloud build deployment.
# ./init.sh PROJECT_ID

# But for local test or deployment, uncomment the next line
export PROJECT_ID=$(gcloud info --format='value(config.project)')
# and comment the next line PROJECT_ID=$1
# PROJECT_ID=sandbox-athevenot

TERRAFORM_BUCKET=$PROJECT_ID-gcs-tfstate-sbx-s

echo "******"
echo "ProjectID value: $PROJECT_ID"
echo "Backend terraform bucket: $TERRAFORM_BUCKET"
echo "******"
echo "GCP basic APIs activation: "
echo "serviceusage.googleapis.com, "
echo "cloudresourcemanager.googleapis.com, "
echo "cloudbuild.googleapis.com, "
echo "artifactregistry.googleapis.com "
echo "******"

gsutil ls -b -p $PROJECT_ID gs://$TERRAFORM_BUCKET || gsutil mb -l eu -p $PROJECT_ID gs://$TERRAFORM_BUCKET || gsutil versioning set on gs://$TERRAFORM_BUCKET # Set versioning on
echo "bucket = \"$TERRAFORM_BUCKET"\" > backend.tfvars
