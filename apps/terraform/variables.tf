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
