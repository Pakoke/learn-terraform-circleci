
resource "aws_lb_target_group" "tg_ecs_blue" {
  name     = "ecs-tg-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    enabled = true
    path    = "/health"
  }
}

resource "aws_lb_target_group" "tg_ecs_green" {
  name     = "ecs-tg-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    enabled = true
    path    = "/health"
  }
}

resource "aws_lb_listener_rule" "dotnetapi_rule" {
  listener_arn = data.aws_lb_listener.default80.arn
  priority     = 2


  action {
    type             = "forward"
    target_group_arn = (var.blue_green == "blue") ? aws_lb_target_group.tg_ecs_blue.arn : aws_lb_target_group.tg_ecs_green.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_ecs_service" "odilo_dotnetapi" {
  name            = "odilo-dotnetapi-service"
  cluster         = data.aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.dotnetapi_task.arn
  desired_count   = 2
  iam_role        = data.aws_iam_role.ecs_service_role.arn
  depends_on      = [aws_lb_target_group.tg_ecs_blue,aws_lb_target_group.tg_ecs_green,aws_ecs_task_definition.dotnetapi_task]
  
  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }
#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }

  load_balancer {
    target_group_arn = (var.blue_green == "blue") ? aws_lb_target_group.tg_ecs_blue.arn : aws_lb_target_group.tg_ecs_green.arn
    container_name   = "dotnetapi"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.region}a, ${var.region}b, ${var.region}c]"
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  health_check_grace_period_seconds = 60

}