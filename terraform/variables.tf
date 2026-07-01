variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID (az account show --query id)"
}

variable "location" {
  type        = string
  description = "Region Azure du lab"
  default     = "francecentral"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group du lab"
  default     = "rg-defender-lab"
}

variable "workspace_id" {
  type        = string
  description = "ID complet du Log Analytics WS existant (lab Sentinel)"
}

variable "workspace_name" {
  type        = string
  description = "Nom du Log Analytics Workspace existant"
}

variable "enable_defender_servers" {
  type    = bool
  default = true
}

variable "enable_defender_storage" {
  type    = bool
  default = true
}

variable "enable_defender_sql" {
  type    = bool
  default = false
}

variable "enable_defender_keyvault" {
  type    = bool
  default = true
}
