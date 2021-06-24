
# Get the parameter created by AWS to get the latest ECS image
data "aws_ssm_parameter" "ami_ecs_latest" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

# Get the latest ami optimize for ECS
data "aws_ami" "ecs_optimized" {
  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.ami_ecs_latest.value]
  }
  most_recent = true
  owners      = ["amazon"]
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

# Define the role that the each EC2 instance is going to use
resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

# Allow EC2 service to assume this role.
data "aws_iam_policy_document" "ecs_agent_permissions" {
  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "ssmmessages:OpenDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:CreateControlChannel",
      "ssm:UpdateInstanceInformation"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "s3:GetEncryptionConfiguration"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecs:StartTelemetrySession",
      "ecs:RegisterContainerInstance",
      "ecs:Poll",
      "ecs:DiscoverPollEndpoint",
      "ecs:DeregisterContainerInstance",
      "ecs:CreateCluster",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ec2:DescribeTags"
    ]

    resources = [
      "*",
    ]
  }
}

# Policy with the exact permissions that the agent need
resource "aws_iam_policy" "ecs_agent_policy" {
  name   = "ecs_agent_permissions"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs_agent_permissions.json
}

# Give this role the permission to do ECS Agent things.
resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = aws_iam_policy.ecs_agent_policy.arn
}

# Instance profile used on our Autoscaling group
resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

# ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

# Autoscaling group where ECS is going to be installed
resource "aws_autoscaling_group" "cluster" {
  name                = var.ecs_cluster_name
  vpc_zone_identifier = var.vpc_private_subnets

  launch_template {
    id      = aws_launch_template.cluster.id
    version = aws_launch_template.cluster.latest_version
  }

  desired_capacity = 2
  min_size         = 2
  max_size         = 3

  tag {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [
      target_group_arns
    ]
  }
}

# Launch template associated to the ECS autoscaling group
resource "aws_launch_template" "cluster" {
  name     = var.ecs_cluster_name
  image_id = data.aws_ami.ecs_optimized.id

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }

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

  vpc_security_group_ids = [aws_security_group.ecs.id]

}
