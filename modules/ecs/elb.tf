# module "alb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "~> 6.2.0"

#   name = "my-alb"

#   load_balancer_type = "application"

#   vpc_id             = var.vpc_id
#   subnets            = var.vpc_public_subnets
#   security_groups    = ["sg-edcd9784", "sg-edcd9785"]

# #   access_logs = {
# #     bucket = "my-alb-logs"
# #   }

#   target_groups = [
#     {
#       name_prefix      = "default"
#       backend_protocol = "HTTP"
#       backend_port     = 80
#       target_type      = "instance"
#     }
#   ]

#   https_listeners = [
#     {
#       port                 = 443
#       certificate_arn      = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
#     }
#   ]

#   https_listener_rules = [
#     {
#       https_listener_index = 0
#       priority             = 5000

#       actions = [{
#         type        = "redirect"
#         status_code = "HTTP_302"
#         host        = "www.youtube.com"
#         path        = "/watch"
#         query       = "v=dQw4w9WgXcQ"
#         protocol    = "HTTPS"
#       }]

#       conditions = [{
#         path_patterns = ["/onboarding", "/docs"]
#       }]
#     }
#   ]
# }


resource "aws_lb_target_group" "tg_80" {
  name     = "odilo-app-80-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# resource "aws_lb_target_group" "443_tg" {
#   name     = "odilo-app-80-tg"
#   port     = 443
#   protocol = "HTTPS"
#   vpc_id   = aws_vpc.main.id
# }

resource "aws_lb" "front_end" {
  name               = "odilo-front-end"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = var.vpc_public_subnets

  enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.front_end.arn
    port              = "80"
    protocol          = "HTTP"
    #ssl_policy        = "ELBSecurityPolicy-2016-08"
    #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg_80.arn
    }
}

# resource "aws_lb_listener_rule" "redirect_http_to_https" {
#   listener_arn = aws_lb_listener.front_end.arn

#   action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }

#   condition {
#     http_header {
#       http_header_name = "X-Forwarded-For"
#       values           = ["192.168.1.*"]
#     }
#   }
# }


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

