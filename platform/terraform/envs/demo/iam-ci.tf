# Shared ECR push permissions, attached to the OIDC role (see iam-oidc.tf).
# The former long-lived IAM user (T-01 baseline) was removed once OIDC
# federation replaced it — there is no static credential anywhere now.
data "aws_iam_policy_document" "ecr_push" {
  statement {
    sid       = "EcrLogin"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "PushOrdersApi"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
    ]
    resources = [aws_ecr_repository.orders_api.arn]
  }
}
