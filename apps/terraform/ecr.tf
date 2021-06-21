resource "aws_ecr_repository" "dotnetapi" {
  name                 = "dotnetapi"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
      encryption_type = "KMS"
  }
}