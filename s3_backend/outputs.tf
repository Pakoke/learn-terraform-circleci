output "s3_terraform_state" {
  value = aws_s3_bucket.terraform_state.bucket
}
output "aws_ecr_default_repository" {
    value = aws_ecr_repository.dotnetapi.repository_url
}
output "account_id" {
    value = data.aws_caller_identity.current.account_id
}