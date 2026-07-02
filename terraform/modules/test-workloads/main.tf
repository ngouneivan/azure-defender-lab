variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "workspace_id"        { type = string }

# Storage Account de test — Defender for Storage
resource "azurerm_storage_account" "test" {
  name                     = "stdefenderlabtest01"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Desactiver l'acces public (bonne pratique)
  allow_nested_items_to_be_public = false

  tags = {
    Project = "defender-for-cloud-lab"
    Phase   = "05-workload-protection"
  }
}

# Key Vault de test — Defender for Key Vault
resource "azurerm_key_vault" "test" {
  name                = "kv-defender-lab-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Soft delete obligatoire
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = {
    Project = "defender-for-cloud-lab"
    Phase   = "05-workload-protection"
  }
}

data "azurerm_client_config" "current" {}

output "storage_account_name" {
  value = azurerm_storage_account.test.name
}

output "key_vault_name" {
  value = azurerm_key_vault.test.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.test.vault_uri
}