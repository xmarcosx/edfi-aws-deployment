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

  credentials = file("service.json")

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
}

resource "google_sql_database" "EdFi_Admin" {
  name     = "EdFi_Admin"
  instance = google_sql_database_instance.master.name
  depends_on = ["master"]
}

resource "google_sql_database" "EdFi_Security" {
  name     = "EdFi_Security"
  instance = google_sql_database_instance.master.name
  depends_on = ["master"]
}

resource "google_sql_database" "EdFi_Ods" {
  name     = "EdFi_Ods"
  instance = google_sql_database_instance.master.name
  depends_on = ["master"]
}

resource "google_sql_user" "users" {
  name     = "postgres"
  instance = google_sql_database_instance.master.name
  host     = "localhost"
  password = var.PG_PASSWORD
  depends_on = ["master"]
}

resource "null_resource" "db_setup" {

  depends_on = ["EdFi_Admin", "EdFi_Security", "EdFi_Ods"]

    provisioner "local-exec" {
        command = "database connection command goes here"
        environment { PGPASSWORD = var.PG_PASSWORD }
    }
}
