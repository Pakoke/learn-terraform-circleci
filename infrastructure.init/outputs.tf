output "S3_TERRAFORM_STATE" {
  value = aws_s3_bucket.terraform_state.bucket
}
output "DEFAULT_ACCOUNT_ID" {
  value = data.aws_caller_identity.current.account_id
}
output "DEFAULT_AWS_REGION" {
  value = data.aws_region.current.name
}
output "DEFAULT_ECR_ACCOUNT_URL" {
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com" 
}
output "AWS_USER_NAME" {
  value = aws_iam_user.circle_ci_pipeline.name
}