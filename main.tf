resource "random_uuid" "randomid" {}

data "aws_region" "current" {}

locals {

}

data "aws_caller_identity" "current" {}

module "ecs_cluster" {
  source     = "./modules/ecs"
  
  vpc_private_subnets                          = "${module.vpc.private_subnets}"
  vpc_public_subnets                           = "${module.vpc.public_subnets}"
  region                                       = var.region
  ecs_cluster_name                             = var.ecs_cluster_name
}
# resource "aws_iam_user" "circleci" {
#   name = var.user
#   path = "/system/"
# }

# resource "aws_iam_access_key" "circleci" {
#   user = aws_iam_user.circleci.name
# }

# data "template_file" "circleci_policy" {
#   template = file("circleci_s3_access.tpl.json")
#   vars = {
#     s3_bucket_arn = aws_s3_bucket.app.arn
#   }
# }

# resource "local_file" "circle_credentials" {
#   filename = "tmp/circleci_credentials"
#   content  = "${aws_iam_access_key.circleci.id}\n${aws_iam_access_key.circleci.secret}"
# }

# resource "aws_iam_user_policy" "circleci" {
#   name   = "AllowCircleCI"
#   user   = aws_iam_user.circleci.name
#   policy = data.template_file.circleci_policy.rendered
# }

# resource "aws_s3_bucket" "app" {
#   tags = {
#     Name = "App Bucket"
#   }

#   bucket = "${var.app}.${var.label}.${random_uuid.randomid.result}"
#   acl    = "public-read"

#   website {
#     index_document = "index.html"
#     error_document = "error.html"
#   }
#   force_destroy = true

# }

# resource "aws_s3_bucket_object" "app" {
#   acl          = "public-read"
#   key          = "index.html"
#   bucket       = aws_s3_bucket.app.id
#   content      = file("./assets/index.html")
#   content_type = "text/html"

# }

# output "Endpoint" {
#   value = aws_s3_bucket.app.website_endpoint
# }
