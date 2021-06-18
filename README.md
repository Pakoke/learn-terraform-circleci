# learn-terraform-circleci

Supplemental repository for Learn content on CircleCI.

For a full step by step guide, see the accompanying guide at [HashiCorp Learn](https://learn.hashicorp.com/terraform/development/circle).

$region="eu-west-2"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin 174301567049.dkr.ecr.eu-west-2.amazonaws.com
docker tag pacokedev/dotnetapi:latest 174301567049.dkr.ecr.eu-west-2.amazonaws.com/dotnetapi:1.0
docker push 174301567049.dkr.ecr.eu-west-2.amazonaws.com/dotnetapi:1.0