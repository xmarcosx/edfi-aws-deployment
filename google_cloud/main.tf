terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.66.1"
    }
  }
}

variable "GOOGLE_CLOUD_PROJECT" {
  type = string
}

variable "PG_PASSWORD" {
  type = string
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

provider "google" {

  credentials = file("../service.json")

  project = var.GOOGLE_CLOUD_PROJECT
  region  = "us-central1"
  zone    = "us-central1-c"

}

resource "google_project_service" "sqladmin" {
  project = var.GOOGLE_CLOUD_PROJECT
  service = "sqladmin.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager" {
  project = var.GOOGLE_CLOUD_PROJECT
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "secretmanager" {
  project  = var.GOOGLE_CLOUD_PROJECT
  service  = "secretmanager.googleapis.com"
}

resource "google_service_account" "service_account" {
  account_id   = "edfi-cloud-run"
  display_name = "Ed-Fi Cloud Run Service Account"
}

resource "google_service_account_iam_member" "service_account_sql_access" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/cloudsql.client"
  member             = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_sql_database_instance" "edfi_ods" {
  name             = "edfi-ods"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
    disk_autoresize = true
    backup_configuration {
      enabled = true
      start_time = "08:00"
    }
    ip_configuration {
      authorized_networks {
        value = "${chomp(data.http.myip.body)}"
      }
    }
  }

  depends_on = [
    google_project_service.sqladmin,
    google_project_service.cloudresourcemanager
  ]
}

resource "google_sql_database" "edfi_admin_db" {
  name     = "EdFi_Admin"
  instance = google_sql_database_instance.edfi_ods.name
  depends_on = [
    google_sql_database_instance.edfi_ods
  ]
}

resource "google_sql_database" "edfi_security_db" {
  name     = "EdFi_Security"
  instance = google_sql_database_instance.edfi_ods.name
  depends_on = [
    google_sql_database_instance.edfi_ods
  ]
}

resource "google_sql_database" "edfi_ods_db" {
  name     = "EdFi_Ods"
  instance = google_sql_database_instance.edfi_ods.name
  depends_on = [
    google_sql_database_instance.edfi_ods
  ]
}

resource "google_sql_user" "users" {
  name     = "postgres"
  instance = google_sql_database_instance.edfi_ods.name
  host     = "localhost"
  password = var.PG_PASSWORD
  depends_on = [
    google_sql_database_instance.edfi_ods
  ]
}

resource "null_resource" "db_setup" {
    provisioner "local-exec" {
        command = "bash import_ods_data.sh ${google_sql_database_instance.edfi_ods.public_ip_address}"
        environment = { PGPASSWORD = var.PG_PASSWORD }
    }

    depends_on = [
      google_sql_database.edfi_ods_db
    ]
}

resource "google_secret_manager_secret" "ods_password_secret" {
  secret_id = "ods-password"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secretmanager
  ]
}

resource "google_secret_manager_secret_version" "ods_password_secret_value" {
  secret      = google_secret_manager_secret.ods_password_secret.id
  secret_data = var.PG_PASSWORD
  depends_on = [
    google_secret_manager_secret.ods_password_secret
  ]
}

resource "google_secret_manager_secret_iam_member" "service_account_secret_access" {
  secret_id = google_secret_manager_secret.ods_password_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_account.email}"
}
