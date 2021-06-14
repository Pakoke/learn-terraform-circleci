data "aws_ami" "ecs_optimized" {
  filter {
    name   = "name"
    values = ["*-amazon-ecs-optimized"]
  }
  most_recent       = true
  owners            = ["amazon"]
}

# Define the role.
resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_agent.json}"
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
  role       = "${aws_iam_role.ecs_agent.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = "${aws_iam_role.ecs_agent.name}"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

resource "aws_autoscaling_group" "cluster" {
  name                 = "${var.ecs_cluster_name}"
  vpc_zone_identifier  = var.vpc_private_subnets
  launch_configuration = "${aws_launch_configuration.cluster.name}"

  desired_capacity = 3
  min_size         = 3
  max_size         = 3
}

resource "aws_launch_configuration" "cluster" {
  name                 = "${var.ecs_cluster_name}"
  image_id             = "${data.aws_ami.ecs_optimized.id}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_agent.name}"
  user_data            = templatefile(join("",[abspath(path.module),"/user_data.yml"]),{cluster_name = var.ecs_cluster_name})
  instance_type        = "t2.micro"
}