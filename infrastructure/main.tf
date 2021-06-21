data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "ecs_cluster" {
  source = "./modules/ecs"

  vpc_private_subnets = module.vpc.private_subnets
  vpc_public_subnets  = module.vpc.public_subnets
  region              = var.region
  ecs_cluster_name    = var.ecs_cluster_name
  vpc_id              = module.vpc.vpc_id
  elb_name            = var.elb_name
}


