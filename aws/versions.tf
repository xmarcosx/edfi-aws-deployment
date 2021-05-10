terraform {
    required_version = ">= 0.15.1"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 3.0"
        }
        postgresql = {
            source = "cyrilgdn/postgresql"
            version = "1.13.0-pre1"
        }
    }
}
