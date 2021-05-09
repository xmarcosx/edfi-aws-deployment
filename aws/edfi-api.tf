resource "aws_ecr_repository" "main" {
    name                 = "edfi-api"
    image_tag_mutability = "MUTABLE"
}
