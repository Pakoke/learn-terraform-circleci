# terraform {
  
#   required_version = "> 0.14"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "3.44.0"
#     }
#   }

#   backend "s3" {
#     bucket = "circle-ci-backend-20210614201950619500000001"
#     key = "terraform/ecs/terraform.tfstate"
#     region = "eu-west-2"
#   }
# }

provider "aws" {
  region = var.region
}