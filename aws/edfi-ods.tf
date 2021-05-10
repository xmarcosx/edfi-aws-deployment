module "db" {

    source  = "terraform-aws-modules/rds/aws"
    version = "~> 3.0"

    identifier = "edfi-ods"

    engine               = "postgres"
    engine_version       = "11.11"
    family               = "postgres11"
    instance_class       = "db.m3.medium"

    allocated_storage     = 20
    max_allocated_storage = 100
    storage_encrypted     = true

    name     = "EdFi_Admin"
    username = "postgres"
    password = var.PG_PASSWORD
    port     = 5432
    publicly_accessible = true

    subnet_ids             = module.vpc.database_subnets
    vpc_security_group_ids = [module.security_group.security_group_id]

    maintenance_window              = "Mon:00:00-Mon:03:00"
    backup_window                   = "03:00-06:00"
    enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

    backup_retention_period = 7

    performance_insights_enabled          = true
    performance_insights_retention_period = 7
    create_monitoring_role                = true
    monitoring_interval                   = 60

}

provider "postgresql" {

    alias           = "edfi_pg"
    host            = module.db.db_instance_address
    port            = 5432
    database        = "EdFi_Admin"
    username        = "postgres"
    password        = var.PG_PASSWORD
    sslmode         = "require"
    connect_timeout = 15

}

resource "postgresql_database" "edfi_security_db" {

    provider = postgresql.edfi_pg
    name     = "EdFi_Security"

}

resource "postgresql_database" "edfi_ods_db" {

    provider = postgresql.edfi_pg
    name     = "EdFi_Ods"

}
