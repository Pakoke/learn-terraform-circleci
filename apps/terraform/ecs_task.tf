# ECS task to define how we are going to deploy the container
resource "aws_ecs_task_definition" "dotnetapi_task" {
  family                = "odilo-dotnetapi-task"
  container_definitions = templatefile(join("", [abspath(path.root), "/../dotnetapi/src/ecs-app-definition.json"]), { ecr_repository = data.aws_ecr_repository.dotnetapi_repo.repository_url })
  cpu = 256
  memory = 256
  execution_role_arn = data.aws_iam_role.ecs_service_role.arn
  task_role_arn = data.aws_iam_role.ecs_service_role.arn
  requires_compatibilities = ["EXTERNAL","EC2"]

}