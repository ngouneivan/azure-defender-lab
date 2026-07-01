output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Nom du Resource Group cree"
}

output "defender_plans_status" {
  description = "Statut des plans Defender"
  value = {
    servers  = var.enable_defender_servers  ? "Standard (P2)" : "Free"
    storage  = var.enable_defender_storage  ? "Standard"      : "Free"
    sql      = var.enable_defender_sql      ? "Standard"      : "Free"
    keyvault = var.enable_defender_keyvault ? "Standard"      : "Free"
  }
}
