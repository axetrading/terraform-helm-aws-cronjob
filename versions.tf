terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.36"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }
  required_version = ">= 1.2.5"

}