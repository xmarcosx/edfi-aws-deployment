provider "aws" {
    region = var.AWS_REGION
}

module "vpc" {

    source  = "terraform-aws-modules/vpc/aws"
    version = "~> 3"

    name = "edfi"
    cidr = "10.99.0.0/18"

    azs              = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"]
    public_subnets   = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
    private_subnets  = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
    database_subnets = ["10.99.7.0/24", "10.99.8.0/24", "10.99.9.0/24"]

    create_database_subnet_group           = true
    create_database_subnet_route_table     = true
    create_database_internet_gateway_route = true

    enable_dns_hostnames = true
    enable_dns_support   = true

}

module "security_group" {

    source  = "terraform-aws-modules/security-group/aws"
    version = "~> 4"

    name        = "edfi"
    description = "Ed-Fi security group"
    vpc_id      = module.vpc.vpc_id

    ingress_with_cidr_blocks = [
        {
            from_port   = 5432
            to_port     = 5432
            protocol    = "tcp"
            description = "PostgreSQL access from within VPC"
            cidr_blocks = module.vpc.vpc_cidr_block
        },
        {
            from_port   = 5432
            to_port     = 5432
            protocol    = "tcp"
            description = "External development machine"
            cidr_blocks = "${chomp(data.http.myip.body)}/32"
        },
        {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            description = "Access to Ed-Fi API and Admin App"
            cidr_blocks = "0.0.0.0/0"
        }
    ]

}

resource "aws_ecr_repository" "main" {
    name                 = "edfi"
    image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "main" {
    repository = aws_ecr_repository.main.name
    
    policy = jsonencode({
    rules = [{
            rulePriority = 1
            description  = "keep last 10 images"
            action       = {
            type = "expire"
        }
        selection       = {
            tagStatus   = "any"
            countType   = "imageCountMoreThan"
            countNumber = 10
        }
    }]
    })
}

resource "aws_ecs_cluster" "main" {
    name = "edfi-cluster"
}

resource "aws_secretsmanager_secret" "ods_password" {
    name = "ods-password"
}

resource "aws_secretsmanager_secret_version" "ods_password_value" {
    secret_id     = aws_secretsmanager_secret.ods_password.id
    secret_string = var.PG_PASSWORD
}
