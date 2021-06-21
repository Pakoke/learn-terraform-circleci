resource "aws_lb_target_group" "tg_ecs" {
  name     = "ecs-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true
    path    = "/health"
  }
}

resource "aws_lb" "front_end" {
  name               = "odilo-front-end"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = var.vpc_public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.front_end.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg_ecs.arn
    }
}



resource "aws_lb_listener_rule" "health_check" {
  listener_arn = aws_lb_listener.front_end.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }
  }

  condition {
    query_string {
      key   = "health"
      value = "check"
    }
  }
}

