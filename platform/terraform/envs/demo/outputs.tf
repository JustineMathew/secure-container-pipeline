output "repository_url" {
  value = aws_ecr_repository.orders_api.repository_url
}

output "ci_user_name" {
  value = aws_iam_user.github_ci_baseline.name
}
