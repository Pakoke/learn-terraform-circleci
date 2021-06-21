# resource "aws_ecs_task_definition" "dotnetapi_task" {
#   family                = "odilo-dotnetapi"
#   container_definitions = <<TASK_DEFINITION
# [
#     {
#         "essential": true,
#         "image": "nginx:latest",
#         "memory": 256,
#         "name": "odilo-ngnix",
#         "portMappings": [
#             {
#                 "containerPort": 80,
#                 "hostPort": 0
#             }
#         ]
#     }
# ]
# TASK_DEFINITION
#     cpu = 256
#     memory = 256
#     execution_role_arn = data.aws_iam_role.ecs_service_role.arn
# }

resource "aws_ecs_task_definition" "dotnetapi_task" {
  family                = "odilo-dotnetapi"
  container_definitions = jsonencode(templatefile(join("", [abspath(path.module), "/../dotnetapi/src/ecs-app-definition.json"])))
  cpu = 256
  memory = 256
  execution_role_arn = data.aws_iam_role.ecs_service_role.arn
}