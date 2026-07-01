resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Project     = "defender-for-cloud-lab"
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}

module "defender_plans" {
  source = "./modules/defender-plans"

  enable_servers  = var.enable_defender_servers
  enable_storage  = var.enable_defender_storage
  enable_sql      = var.enable_defender_sql
  enable_keyvault = var.enable_defender_keyvault
  workspace_id    = var.workspace_id
}

module "test_workloads" {
  source              = "./modules/test-workloads"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  workspace_id        = var.workspace_id
  depends_on          = [module.defender_plans]
}
