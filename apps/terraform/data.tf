data "aws_iam_role" "ecs_service_role" {
  name = "ecs-service-role"
}

data "aws_vpc" "selected" {
  default = false
}

data "aws_lb" "front_end" {
  name = var.elb_name
}
data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.ecs_cluster_name
}