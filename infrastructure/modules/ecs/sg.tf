
resource "aws_security_group" "elb" {
  name        = "frontend-elb"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "elb_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.elb.id
  description       = "Managed by Terraform"
}

resource "aws_security_group_rule" "elb_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.elb.id
  description       = "Managed by Terraform"
}

resource "aws_security_group_rule" "elb_allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 0
  security_group_id = aws_security_group.elb.id
}

resource "aws_security_group" "ecs" {
  name        = "app-ecs"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id

}

resource "aws_security_group_rule" "ecs_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.ecs.id
  description       = "Managed by Terraform"
}

resource "aws_security_group_rule" "ecs_elb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb.id
  security_group_id        = aws_security_group.ecs.id
  description              = "Managed by Terraform"
}

resource "aws_security_group_rule" "ecs_allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 0
  security_group_id = aws_security_group.ecs.id
}