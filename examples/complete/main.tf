provider "aws" {
  region = var.aws_region
}

resource "aws_iam_policy" "deployer" {
  name        = "gitlab-deployer-policy"
  description = "GitLab Deployer"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
EOT
}

module "aws_oidc_gitlab" {

  for_each = var.gitlab
  source   = "../../"


  attach_admin_policy  = false
  create_oidc_provider = true
  iam_role_name        = each.value.iam_role_name
  iam_policy_arns      = each.value.policy_arns
  gitlab_url           = each.value.gitlab_url
  audience             = each.value.audience
  match_field          = each.value.match_field
  match_value          = each.value.match_value
}
