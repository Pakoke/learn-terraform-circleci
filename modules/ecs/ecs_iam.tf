# Allow ECS service to assume this role.
data "aws_iam_policy_document" "ecs_service_document_assumepermissions" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com","ecs.amazonaws.com"]
    }
  }
}
# Define the role.
resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs-service-role"
  description        = "Allows ECS tasks to call AWS services on your behalf. Managed by Terraform"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_document_assumepermissions.json
}

# Additional Permissions ECS service
data "aws_iam_policy_document" "ecs_service_document_additionalpermissions" {
  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
      "ecr:Get*",
      "ecr:Describe*",
      "ecr:List*",
      "ecr:Batch*"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecs_service_policy" {
  name   = "ecs_service_permissions"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs_service_document_additionalpermissions.json
}


# Give this role the permission to do ECS Agent things.
resource "aws_iam_role_policy_attachment" "ecs_service_policy_attachment" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = aws_iam_policy.ecs_service_policy.arn
}


# resource "aws_ecs_task_definition" "web_server" {
#   family                = "odilo-webserver"
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
#     execution_role_arn = aws_iam_role.ecs_service_role.arn
# }