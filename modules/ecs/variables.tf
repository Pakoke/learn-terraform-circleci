variable "vpc_private_subnets" {
  type = set(string)
  description = "This is are the list of private subnet which the ecs is going to be deployed."
}

variable "vpc_public_subnets" {
  type = set(string)
  description = "This is are the list of public subnets which the ELB is going to be deployed."
}

variable "region" {
    type = string
    description = "This is the regions where Terraform is going to deploy everything"
}

variable "ecs_cluster_name"{
    type = string
    description = "Name of the ECS cluster"
}