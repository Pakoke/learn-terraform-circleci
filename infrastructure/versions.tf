terraform {
  required_version = "> 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.44.0"
    }
  }

  backend "s3" {
    bucket = var.s3_terraform_backend
    key    = "terraform/webapp/terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = var.region
}