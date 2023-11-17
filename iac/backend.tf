terraform {
  required_version = ">= 0.15"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"
    }
  }
  backend "gcs" { 
    bucket = "sandbox-vvaneecloo-gcs-tfstate-sbx" 
    prefix = "terraform-states"
  }
}

provider "google" {
    project = "sandbox-vvaneecloo"
    region = "europe-west3"
}


#Ce qui va se passer: connect to terraform w/ compte utilisateur de celui qui lance terraform
  #récupère le tfstate -> tenu à jour pour pouvoir versionner ton infra, si l'infra existe déjà

#bucket -> moi qui ait accès à ce bucket en lecture + écriture
    #Next steps:
      #Boucle terraform
      #Execute le code via 'terraform apply'
      #Bon moyen de créer un bucket pour stocker le tfstate -> Soit créer à la main, soit créer via terminal

#Comment déployer ton projet avec terraform
#1. terraform init
#2. terraform plan
#3. terraform apply