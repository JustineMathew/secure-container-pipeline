# GitHub's OIDC identity provider. AWS will trust tokens signed by GitHub.
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

locals {
  github_repo = "JustineMathew/secure-container-pipeline"
}

# Trust policy: only tokens from the main branch of this repo may assume the role.
data "aws_iam_policy_document" "github_ci_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:JustineMathew@*/secure-container-pipeline@*:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_ci" {
  name                 = "github-ci-oidc"
  assume_role_policy   = data.aws_iam_policy_document.github_ci_trust.json
  max_session_duration = 3600
}

# Same ECR push permissions as before, now attached to the role.
resource "aws_iam_role_policy" "github_ci_ecr" {
  name   = "ecr-push-orders-api"
  role   = aws_iam_role.github_ci.id
  policy = data.aws_iam_policy_document.ecr_push.json
}
