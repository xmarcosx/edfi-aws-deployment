resource "aws_apprunner_service" "edfi_api" {
    service_name = "edfi_api"

    source_configuration {
        image_repository {
            image_configuration {
                port = "8000"
                runtime_environment_variables {
                    rds_endpoint = ""
                }
            }
            image_identifier      = "${var.container_image}:latest"
            image_repository_type = "ECR"
        }
    }

    tags = {
        Name = "edfi-api-apprunner-service"
    }
}
