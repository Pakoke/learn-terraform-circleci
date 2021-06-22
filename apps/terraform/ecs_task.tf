resource "aws_ecs_task_definition" "dotnetapi_task" {
  family                = "odilo-dotnetapi-task"
  #container_definitions = jsonencode(templatefile(join("", [abspath(path.root), "/../dotnetapi/src/ecs-app-definition.json"]),{ cluster_name = var.ecs_cluster_name }))
  container_definitions = templatefile(join("", [abspath(path.root), "/../dotnetapi/src/ecs-app-definition.json"]), { ecr_repository = data.aws_ecr_repository.dotnetapi_repo.repository_url })
  cpu = 256
  memory = 256
  execution_role_arn = data.aws_iam_role.ecs_service_role.arn
  task_role_arn = data.aws_iam_role.ecs_service_role.arn
  requires_compatibilities = ["EXTERNAL","EC2"]

}