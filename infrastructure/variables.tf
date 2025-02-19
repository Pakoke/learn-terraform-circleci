variable "region" {
  type        = string
  description = "This is the regions where Terraform is going to deploy everything"
}
variable "user" {
  type        = string
  description = "User name that it's going to be used to deploy resources"
}
variable "label" {

}
variable "app" {
  type        = string
  description = "Name of the app in our DNS"
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