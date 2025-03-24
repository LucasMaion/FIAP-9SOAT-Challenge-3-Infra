resource "aws_ecr_repository" "app_repository" {
  name                 = "application-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
