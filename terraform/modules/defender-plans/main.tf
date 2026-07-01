data "azurerm_client_config" "current" {}

resource "azurerm_security_center_subscription_pricing" "servers" {
  count         = var.enable_servers ? 1 : 0
  tier          = "Standard"
  resource_type = "VirtualMachines"
  subplan       = "P2"
}

resource "azurerm_security_center_subscription_pricing" "storage" {
  count         = var.enable_storage ? 1 : 0
  tier          = "Standard"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "sql" {
  count         = var.enable_sql ? 1 : 0
  tier          = "Standard"
  resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "keyvault" {
  count         = var.enable_keyvault ? 1 : 0
  tier          = "Standard"
  resource_type = "KeyVaults"
}

resource "azurerm_security_center_workspace" "main" {
  scope        = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  workspace_id = var.workspace_id
}
