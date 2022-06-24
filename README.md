# Welcome to this Learning Practical Path for Data Engineer

## Clone repository and create your own branch


Open your VS Code and clone the repository in ssh mode `git@github.com:devoteamgcloud/dgc-learning-path-data-template.git`

Or from your console. 

```bash
mkdir your/directory/to/clone
cd your/directory/to/clone
git clone git@github.com:devoteamgcloud/dgc-learning-path-data-template.git
```


Then create your own branch replacing `<your-sandbox-project-id>` with your GCP Sandbox project ID for instance. 


```bash
git checkout -b <your-sandbox-project-id>
git push --set-upstream origin <your-sandbox-project-id> 
```

## Configure your G Cloud SDK

### Install G Cloud CLI

https://cloud.google.com/sdk/docs/install-sdk

### Authenticate

To have a default authentication

```bash
gcloud auth application-default login
```

or 

```bash
gcloud auth login
```

## Configure your Cloud Build Trigger


Create your `PROJECT_ID` environment variable

```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')
```

Activate GCP APIs

```bash
gcloud services enable serviceusage.googleapis.com cloudresourcemanager.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com --project $PROJECT_ID
```

Adds the `Editor` role to the SA Cloud build

```bash
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")@cloudbuild.gserviceaccount.com" \
    --role="roles/editor"
```

Then Go to the GCP Console to the [Cloud Build interface](https://console.cloud.google.com/cloud-build/builds) from your project id.
- In the left panel, click on `Triggers` then `+ CREATE TRIGGER`
- add a trigger name (for instance `trigger-learning-path`)
- In `Source -> Repository`, connect to the repository.
- In `Source -> Branch`, add your branch name.
- leave everything as default and click on `CREATE`.

