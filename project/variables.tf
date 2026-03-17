
variable "rg_name" {
    description = "The name of the resource group in Azure"
    type = string
    default = "Lab-Migrate-Training"
}

variable "project_location" {
    description = "The location of the project in Azure.  Must be one of the supported locations"
    type = string
    default = "centralus"
}

variable "project_name" {
    description = "The name of the project in Azure"
    type = string
    default = "migrateproj"
}

variable "api_version" {
    description = "The API version to use for the migrate project resource"
    type = string
    default = "2020-06-01-preview"
}

variable "schema_validation_enabled" {
    description = "Enable schema validation for the migrate project resource"
    type = bool
    default = false
}

variable "replication_rg_name" {
    description = "The name of the resource group to be used for replication"
    type = string
    default = "Training-Migrate-Replication"
}

variable "replication_rg_location" {
    description = "The location of the resource group to be used for replication."
    type = string
    default = "eastus2"
}

variable "replication_sa_name" {
    description = "The name of the storage account to be used for replication.  Must be globally unique and between 3 and 24 characters in length, and can contain only lowercase letters and numbers."
    type = string
    default = "trainingmigrationstorage"
}

variable "vnet_name" {
    description = "The name of the virtual network"
    type = string
    default = "migrate-vnet"
}

variable "vnet_address_space" {
    description = "The address space for the virtual network"
    type = list(string)
    default = ["10.0.0.0/16"]
}

variable "subnet_name" {
    description = "The name of the subnet"
    type = string
    default = "migrate-subnet"
}

variable "subnet_address_prefixes" {
    description = "The address prefixes for the subnet"
    type = list(string)
    default = ["10.0.1.0/24"]
}