resource "aws_ecr_repository" "orders_api" {
  name = "orders-api"

  # Deliberately insecure (T-02): tags can be overwritten
  image_tag_mutability = "MUTABLE"

  # Deliberately off: no automatic vulnerability scan on push
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_lifecycle_policy" "orders_api" {
  repository = aws_ecr_repository.orders_api.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the 10 most recent images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = { type = "expire" }
    }]
  })
}
