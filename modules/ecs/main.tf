data "aws_ami" "ecs_optimized" {
  filter {
    name   = "name"
    values = ["*-amazon-ecs-optimized"]
  }
  most_recent = true
  owners      = ["amazon"]
}

# Define the role.
resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

# Allow EC2 service to assume this role.
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Give this role the permission to do ECS Agent things.
resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

resource "aws_autoscaling_group" "cluster" {
  name                = var.ecs_cluster_name
  vpc_zone_identifier = var.vpc_private_subnets
  # launch_configuration = "${aws_launch_configuration.cluster.name}"

  launch_template {
    id      = aws_launch_template.cluster.id
    version = aws_launch_template.cluster.latest_version
  }

  desired_capacity = 2
  min_size         = 2
  max_size         = 3

  # instance_refresh {
  #   strategy = "Rolling"
  #   preferences {
  #     min_healthy_percentage = 50
  #   }
  #   triggers = ["tag"]
  # }

  tag {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_ecs" {
  autoscaling_group_name = aws_autoscaling_group.cluster.id
  alb_target_group_arn   = aws_lb_target_group.tg_80.arn
}

resource "aws_launch_template" "cluster" {
  name     = var.ecs_cluster_name
  image_id = data.aws_ami.ecs_optimized.id

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }

  # iam_instance_profile = "${aws_iam_instance_profile.ecs_agent.name}"
  user_data     = base64encode(templatefile(join("", [abspath(path.module), "/user_data.yml"]), { cluster_name = var.ecs_cluster_name }))
  instance_type = "t3a.micro"

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
      encrypted   = true
      volume_type = "gp3"
    }
  }

  # instance_market_options {
  #   market_type = "spot"
  # }

  vpc_security_group_ids = [aws_security_group.ecs.id]
  #TODO
  #If we specified another instance type, change the cpu credits
  # credit_specification {
  #   cpu_credits = "standards"
  # }

}

# resource "aws_launch_configuration" "cluster" {
#   name                 = "${var.ecs_cluster_name}"
#   image_id             = "${data.aws_ami.ecs_optimized.id}"
#   iam_instance_profile = "${aws_iam_instance_profile.ecs_agent.name}"
#   user_data            = templatefile(join("",[abspath(path.module),"/user_data.yml"]),{cluster_name = var.ecs_cluster_name})
#   instance_type        = "t2.micro"
# }

resource "aws_ecs_task_definition" "jenkins" {
  family                = "jenkins"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": 10,
        "command": ["sleep", "10"],
        "entryPoint": ["/"],
        "environment": [
            {"name": "VARNAME", "value": "VARVAL"}
        ],
        "essential": true,
        "image": "jenkins",
        "memory": 128,
        "name": "jenkins",
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 8080
            }
        ]
    }
]
TASK_DEFINITION

}