#------------------------------------------------------------------------------------------- 
# Shared variables
#------------------------------------------------------------------------------------------- 
variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
  type        = string
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)
}

variable "subscription_role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
  }))
}

variable "subscription_scope" {
  description = "Scope of the role assignment."
  type        = string
}

#------------------------------------------------------------------------------------------- 
# Resource group variables
#------------------------------------------------------------------------------------------- 
variable "resource_groups" {
  type = map(object({}))
}

variable "rg_role_assignments" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
    resource_group_name  = string
  }))
  description = "Mapped object of resource group role assignment properties to create."
  default     = {}
}

#------------------------------------------------------------------------------------------- 
# Key vault variables
#------------------------------------------------------------------------------------------- 
variable "key_vaults" {
  type = map(object({
    sku_name                   = string
    soft_delete_retention_days = number
    network_default_action     = string
    network_bypass             = string
    resource_group_name        = string
  }))
  description = "Complex String of key vault settings"
  default     = {}
}


variable "keyvault_private_endpoints" {
  type = map(object({
    subnet_id                       = string
    private_dns_zone_group_name     = string
    private_dns_zone_ids            = list(string)
    private_service_connection_name = string
    subresource_names               = list(string)
  }))
  description = "Complex String of private endpoint properties to create."
}

#------------------------------------------------------------------------------------------- 
# Key vault access policy variables
#------------------------------------------------------------------------------------------- 
variable "kv_accesspolicy" {
  type = map(object({
    certificate_permissions        = list(any)
    key_permissions                = list(any)
    service_principal_object_id    = optional(string)
    service_principal_display_name = optional(string)
    secret_permissions             = list(any)
    storage_permissions            = list(any)
    key_vault_name                 = string
  }))
  description = "Complex String of key vault access"
}

#------------------------------------------------------------------------------------------- 
# Key vault diagnostics variables
#------------------------------------------------------------------------------------------- 
variable "key_vault_diagnostics" {
  type = map(object({
    enable_auditevent_log                   = bool
    enable_azurepolicyevaluationdetails_log = bool
    eventhub_name                           = string
    eventhub_authorization_rule_id          = string
    key_vault_name                          = string
    log_analytics_workspace                 = string
  }))
  description = "Complex String of key vault diagnostic settings"
}

#------------------------------------------------------------------------------------------- 
# Storage Account variables
#------------------------------------------------------------------------------------------- 
variable "storage_accounts" {
  type = map(object({
    account_tier             = string
    resource_group_name      = string
    account_replication_type = string
    account_kind             = string
    multichannel_enabled     = bool
    network_default_action   = string
    network_ip_rules         = list(string)
    resource_group_name      = string
    azure_files_authentication = set(object({
      directory_type = string
      active_directory = set(object({
        domain_guid         = string
        domain_name         = string
        domain_sid          = string
        forest_name         = string
        netbios_domain_name = string
        storage_sid         = string
      }))
    }))
  }))
  description = "Complex String of storage account properties to create"
  default     = {}
}

variable "sa_containers" {
  type = map(object({
    container_access_type = string
    storage_account_name  = string
  }))
  description = "Mapped object of storage account container properties to create."
  default     = {}
}

variable "sa_role_assignments" {
  type = map(object({
    role_definition_name           = string
    service_principal_display_name = optional(string)
    service_principal_object_id    = optional(string)
    storage_account_name           = string
  }))
  description = "Mapped object of storage account role assignment properties to create."
  default     = {}
}

variable "file_shares" {
  type = map(object({
    quota                = number # Size in GB's of the File Share being created
    enabled_protocol     = string # The protocol used for the share. Possible values are SMB and NFS
    storage_account_name = string
  }))
  description = "Complex String of File Shares"
}

variable "storage_private_endpoints" {
  type = map(object({
    subnet_id                       = string
    private_dns_zone_group_name     = string
    private_dns_zone_ids            = list(string)
    private_service_connection_name = string
    subresource_names               = list(string)
    storage_account_name            = string
    resource_group_name             = string
  }))
  description = "Complex String of private endpoint properties to create."
}

#------------------------------------------------------------------------------------------- 
# Storage Account Diagnostics variables
#------------------------------------------------------------------------------------------- 
variable "storage_account_diagnostics" {
  type = map(object({
    eventhub_name                  = string
    eventhub_authorization_rule_id = string
    enable_storageread_log         = bool
    enable_storagewrite_log        = bool
    enable_storagedelete_log       = bool
    enable_capacity_metric         = bool
    enable_transaction_metric      = bool
    log_analytics_workspace        = string
    storage_account_name           = string
    storage_account_type           = string
  }))
  description = "Complex String of private endpoint properties to create."
}

variable "storage_account_type" {
  description = "The type of the storage account being referenced"
  type        = string
  default     = null
}

#------------------------------------------------------------------------------------------- 
# Log analytics workspace variables
#------------------------------------------------------------------------------------------- 
variable "log_analytics_workspaces" {
  type = map(object({
    log_workspace_sku          = string
    log_workspace_retention    = string
    internet_ingestion_enabled = string
    internet_query_enabled     = string
    resource_group_name        = string
  }))
  description = "Complex String of log analytics workspace properties to create."
}

variable "log_analytics_workspace_role_assignments" {
  type = map(object({
    role_definition_name    = string
    principal_id            = string
    log_analytics_workspace = string
  }))
}

#------------------------------------------------------------------------------------------- 
# Private Endpoints and DNS zone link variables
#------------------------------------------------------------------------------------------- 
variable "dns_resource_group_name" {
  description = "Name of the resource group that holds the private DNS zones."
  type        = string
}

#------------------------------------------------------------------------------------------- 
# Service principal variables
#------------------------------------------------------------------------------------------- 
variable "spn_required" {
  type        = bool
  description = "Set to true if service principal is required for this deployment, false if not."
}

variable "applications" {
  type = map(object({
  }))
  description = "Complex String of service principal enterprise application properties to create."
  default     = {}
}

variable "service_principals" {
  type = map(object({
    application_display_name = string
  }))
  description = "Complex String service principal properties to create."
  default     = {}
}

variable "application_password" {
  type = map(object({
    application_display_name = string
  }))
  description = "Complex String of serivce principal passwords to create."
  default     = {}
}

variable "key_vault_spn_secrets" {
  type = map(object({
    spn_display_name = string
    password_name    = string
  }))
  description = "List of service principal secrets to create"
  default     = {}
}

variable "key_vault_id" {
  description = "ID of the key vault being referenced."
  type        = string
}

variable "spn_owner" {
  description = "(Optional) A set of object IDs of principals that will be granted ownership of the service principal. Supported object types are users or service principals. By default, no owners are assigned."
  type        = set(string)
  default     = null
}

variable "spn_role_assignments" {
  type = map(object({
    role_definition_name           = string
    service_principal_display_name = optional(string)
    service_principal_object_id    = optional(string)
    scope                          = string
  }))
  description = "List of service principal role assignments to assign to resource group."
  default     = {}
}
