output "project_name" {
    description = "Project name"
    value       = azapi_resource.project.name
}

output "project_resource_group_name" {
    description = "Resource group name of the migrate project"
    value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
    description = "Storage account name used for replication"
    value       = var.replication_sa_name
}

output "replication_resource_group_name" {
    description = "Resource group name used for replication"
    value       = azurerm_resource_group.replication_rg.name
}

