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

resource "google_sql_database_instance" "master" {
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

resource "google_sql_database" "edfi_admin" {
  name     = "EdFi_Admin"
  instance = google_sql_database_instance.master.name
  depends_on = [
    google_sql_database_instance.master
  ]
}

resource "google_sql_database" "edfi_security" {
  name     = "EdFi_Security"
  instance = google_sql_database_instance.master.name
  depends_on = [
    google_sql_database_instance.master
  ]
}

resource "google_sql_database" "edfi_ods" {
  name     = "EdFi_Ods"
  instance = google_sql_database_instance.master.name
  depends_on = [
    google_sql_database_instance.master
  ]
}

resource "google_sql_user" "users" {
  name     = "postgres"
  instance = google_sql_database_instance.master.name
  host     = "localhost"
  password = var.PG_PASSWORD
  depends_on = [
    google_sql_database_instance.master
  ]
}

resource "null_resource" "db_setup" {
    provisioner "local-exec" {
        command = "bash import_ods_data.sh ${google_sql_database_instance.master.public_ip_address}"
        environment = { PGPASSWORD = var.PG_PASSWORD }
    }

    depends_on = [
      google_sql_database.edfi_ods
    ]
}
