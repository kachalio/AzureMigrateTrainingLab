terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  } 
}

provider "azapi" {
  # Configuration options

}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
# Resource Group for project
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.project_location
}

###
### This first block corresponds to creating a new project in the portal from the Migrate Hub
###

# Creates the Migrate Project
resource "azapi_resource" "project" {
  type      = "Microsoft.Migrate/migrateProjects@${var.api_version}"
  name      = var.project_name
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location
  schema_validation_enabled = var.schema_validation_enabled

  body = {
    properties = {}
  }
}

# resource to update the migrate project that registers the assessment tool
resource "azapi_resource_action" "server_assessment" {
  type                   = "Microsoft.Migrate/migrateProjects@${var.api_version}"
  resource_id            = azapi_resource.project.id
  action                 = "solutions/Servers-Assessment-ServerAssessment"
  method                 = "PUT"
  response_export_values = ["*"]
  

  body = {
    properties = {
      tool    = "ServerAssessment",
      purpose = "Assessment",
      goal    = "Servers",
      status  = "Active",
      details = null
    }
  }
}

# resource to update the migrate project that registers the discovery tool
resource "azapi_resource_action" "server_discovery" {
  type                   = "Microsoft.Migrate/migrateProjects@${var.api_version}"
  resource_id            = azapi_resource.project.id
  action                 = "solutions/Servers-Discovery-ServerDiscovery"
  method                 = "PUT"
  response_export_values = ["*"]
  

  body = {
    properties = {
      tool    = "ServerDiscovery",
      purpose = "Discovery",
      goal    = "Servers",
      status  = "Inactive",
      details = null
    }
  }
}

# resource to update the migrate project that registers Migration tool
resource "azapi_resource_action" "server_migration" {
  type                   = "Microsoft.Migrate/migrateProjects@${var.api_version}"
  resource_id            = azapi_resource.project.id
  action                 = "solutions/Servers-Migration-ServerMigration"
  method                 = "PUT"
  response_export_values = ["*"]

  body = {
    properties = {
      tool    = "ServerMigration",
      purpose = "Migration",
      goal    = "Servers",
      status  = "Active",
      details = null
    }
  }
}

# resource to update the migrate project that registers Modernization tool
resource "azapi_resource_action" "server_modernization" {
  type                   = "Microsoft.Migrate/migrateProjects@${var.api_version}"
  resource_id            = azapi_resource.project.id
  action                 = "solutions/DataCenter-Migration-Modernization"
  method                 = "PUT"
  response_export_values = ["*"]

  body = {
    properties = {
      tool    = "Modernization",
      purpose = "Migration",
      goal    = "Servers",
      status  = "Inactive"
    }
  }
}

resource "azurerm_resource_group" "replication_rg" {
  name     = var.replication_rg_name
  location = var.replication_rg_location
}

resource "azurerm_storage_account" "replication_sa" {
  name                     = var.replication_sa_name
  resource_group_name      = azurerm_resource_group.replication_rg.name
  location                 = azurerm_resource_group.replication_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  shared_access_key_enabled = true
  public_network_access_enabled = false

  tags = { "SecurityControl" =  "Ignore"}
  
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.replication_rg.location
  resource_group_name = azurerm_resource_group.replication_rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.replication_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes
}




