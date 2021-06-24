resource "aws_iam_user" "circle_ci_pipeline" {
  name = "circle-ci-pipeline"
  path = "/automation/"
}

resource "aws_iam_user_policy_attachment" "amazons3fullaccess" {
  user       = aws_iam_user.circle_ci_pipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user_policy_attachment" "amazonec2fullaccess" {
  user       = aws_iam_user.circle_ci_pipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy" "circle_ci_pipeline_user_policy" {
  name = "ci-permissions"
  user = aws_iam_user.circle_ci_pipeline.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecs:UpdateCluster",
                "ecr:Describe*",
                "codedeploy:PutLifecycleEventHookExecutionStatus",
                "iam:RemoveRoleFromInstanceProfile",
                "ecs:StartTask",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "codedeploy:CreateDeploymentGroup",
                "ecs:DescribeTaskDefinition",
                "iam:AddRoleToInstanceProfile",
                "ecr:DeleteRepository",
                "ecs:UpdateService",
                "iam:DetachRolePolicy",
                "iam:ListAttachedRolePolicies",
                "ecs:RegisterTaskDefinition",
                "ecs:StopTask",
                "ecs:DeregisterContainerInstance",
                "iam:ListRolePolicies",
                "ecr:BatchCheckLayerAvailability",
                "ecs:CreateTaskSet",
                "codedeploy:UpdateApplication",
                "ecs:UpdateClusterSettings",
                "codedeploy:DeleteDeploymentConfig",
                "codedeploy:RegisterApplicationRevision",
                "ecs:CreateCluster",
                "ecr:CreateRepository",
                "ecr:GetDownloadUrlForLayer",
                "ecs:DeleteService",
                "ecs:DeleteCluster",
                "iam:DeleteRole",
                "ecr:GetAuthorizationToken",
                "ecs:DeleteTaskSet",
                "kms:RetireGrant",
                "ecs:DescribeClusters",
                "ecr:PutImage",
                "ecr:List*",
                "ecr:BatchGetImage",
                "codedeploy:DeleteApplication",
                "iam:DeleteServiceLinkedRole",
                "ecr:InitiateLayerUpload",
                "iam:CreateInstanceProfile",
                "codedeploy:CreateApplication",
                "codedeploy:CreateDeployment",
                "iam:DeletePolicy",
                "codedeploy:DeregisterOnPremisesInstance",
                "ecr:UploadLayerPart",
                "ecr:ListImages",
                "codedeploy:CreateDeploymentConfig",
                "codedeploy:UpdateDeploymentGroup",
                "ecs:DeregisterTaskDefinition",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole",
                "iam:Get*",
                "ecs:CreateService",
                "codedeploy:ListTagsForResource",
                "ecr:CompleteLayerUpload",
                "ecs:DescribeServices",
                "iam:CreatePolicyVersion",
                "ecs:UpdateTaskSet",
                "iam:DeleteInstanceProfile",
                "codedeploy:ContinueDeployment",
                "codedeploy:DeleteDeploymentGroup",
                "iam:CreatePolicy",
                "codedeploy:Get*",
                "iam:ListPolicyVersions",
                "iam:DeletePolicyVersion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ssm:GetParameter",
            "Resource": "arn:aws:ssm:*::parameter/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id*"
        }
    ]
}
EOF
}