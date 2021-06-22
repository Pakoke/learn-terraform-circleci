variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "This is the regions where Terraform is going to deploy everything"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "elb_name" {
  type = string
  description = "Unique name for the ELB used on the ECS cluster"
}

variable "vpc_name" {
  type = string
  description = "VPC Name"
}

variable "blue_green" {
  type = string
  description = "This variable is going to be used to prepare our Terraform plan in case we are in a blue or a green case"
}