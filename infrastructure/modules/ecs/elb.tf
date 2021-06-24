# Create the ELB to externally public the application
resource "aws_lb" "front_end" {
  name               = var.elb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = var.vpc_public_subnets

  enable_deletion_protection = false


}

# Default listener to test that it's working
resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.front_end.arn
    port              = "80"
    protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }
    order = 5000
  }
}

//Default listener rule to add an additional way to check that the ELB is healthy
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

