provider "aws" {
    region = var.AWS_REGION
    version = "~> 3.0"
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

    enable_dns_hostnames = true
    create_database_nat_gateway_route = true

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
            cidr_blocks = ["0.0.0.0/0"]
        }
    ]

}
