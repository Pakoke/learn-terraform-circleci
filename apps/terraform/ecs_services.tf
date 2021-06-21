
resource "aws_lb_target_group" "tg_ecs_1" {
  name     = "ecs-tg-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    enabled = true
    path    = "/health"
  }
}

resource "aws_lb_listener" "front_end" {
    load_balancer_arn = data.aws_lb.front_end.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg_ecs_1.arn
    }
}


resource "aws_ecs_service" "odilo-dotnetapi" {
  name            = "odilo-dotnetapi"
  cluster         = data.aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.dotnetapi_task.arn
  desired_count   = 2
  iam_role        = data.aws_iam_role.ecs_service_role.arn
  depends_on      = [aws_lb_target_group.tg_ecs_1]

#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_ecs_1.arn
    container_name   = "odilo-dotnetapi"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.region}a, ${var.region}b, ${var.region}c]"
  }
}