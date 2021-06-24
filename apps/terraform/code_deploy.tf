# Bucket to storage our deployment specs
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "codedeploy-appspec-2021odilo"
  acl    = "private"

  versioning = {
    enabled = false
  }

  lifecycle_rule = [
    {
      id      = "principal"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
          }, {
          days          = 60
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days = 90
      }

      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]
}

# Upload the file at terraform apply
resource "aws_s3_bucket_object" "dotnetapi_appspec" {
  bucket = module.s3_bucket.s3_bucket_id
  key    = "dotnetapi-app/appspec.json"
  content_base64 = base64encode(templatefile(join("", [abspath(path.root), "/appspec.json"]), { dotnet_task_definition = aws_ecs_task_definition.dotnetapi_task.arn }))

  etag = md5("./appspec.json")
}

resource "aws_iam_role" "codedeploy_role" {
  name = "ecs-codedeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.codedeploy_role.name
}

# Create the AWS CodeDeploy app specific for dotnetapi
resource "aws_codedeploy_app" "dotnetapi_app" {
  compute_platform = "ECS"
  name             = "dotnetapi-app"
}

# Create an specific deployment group to do a blue green deployment
resource "aws_codedeploy_deployment_group" "dotnetapi_deploymentgroup" {
  app_name               = aws_codedeploy_app.dotnetapi_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "dotnetapi-deploymentgroup"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 2
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = aws_ecs_service.odilo_dotnetapi.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [data.aws_lb_listener.default80.arn]
      }

      target_group {
        name = aws_lb_target_group.tg_ecs_blue.name
      }

      target_group {
        name = aws_lb_target_group.tg_ecs_green.name
      }
    }
  }
}