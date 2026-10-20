# Deliberately insecure (T-01): a long-lived IAM user for CI.
# Its access key is created outside Terraform (see README) and stored
# as a GitHub secret. Replaced by OIDC federation in Phase 1.
resource "aws_iam_user" "github_ci_baseline" {
  name = "github-ci-baseline"
}

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

resource "aws_iam_user_policy" "github_ci_baseline" {
  name   = "ecr-push-orders-api"
  user   = aws_iam_user.github_ci_baseline.name
  policy = data.aws_iam_policy_document.ecr_push.json
}
