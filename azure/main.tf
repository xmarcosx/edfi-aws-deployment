terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.57.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "PG_PASSWORD" {
  type = string
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_resource_group" "edfi_resource_group" {
  name     = "edfi"
  location = "Central US"
}

resource "azurerm_postgresql_server" "edfi_ods" {
  name                = "edfi-ods"
  location            = azurerm_resource_group.edfi_resource_group.location
  resource_group_name = azurerm_resource_group.edfi_resource_group.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  auto_grow_enabled            = true

  administrator_login          = "postgres"
  administrator_login_password = var.PG_PASSWORD
  version                      = "11"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "edfi_admin_db" {
  name                = "EdFi_Admin"
  resource_group_name = azurerm_resource_group.edfi_resource_group.name
  server_name         = azurerm_postgresql_server.edfi_ods.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_database" "edfi_security_db" {
  name                = "EdFi_Security"
  resource_group_name = azurerm_resource_group.edfi_resource_group.name
  server_name         = azurerm_postgresql_server.edfi_ods.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_database" "edfi_ods_db" {
  name                = "EdFi_Ods"
  resource_group_name = azurerm_resource_group.edfi_resource_group.name
  server_name         = azurerm_postgresql_server.edfi_ods.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "allow_ip_sql_access" {
  name                = "development"
  resource_group_name = azurerm_resource_group.edfi_resource_group.name
  server_name         = azurerm_postgresql_server.edfi_ods.name
  start_ip_address    = "${chomp(data.http.myip.body)}"
  end_ip_address      = "${chomp(data.http.myip.body)}"
}
