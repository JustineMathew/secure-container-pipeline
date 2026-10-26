output "repository_url" {
  value = aws_ecr_repository.orders_api.repository_url
}


output "github_ci_role_arn" {
  value = aws_iam_role.github_ci.arn
}
