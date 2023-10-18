#------------------------------------------------------------------------------------------- 
# Storage account
#------------------------------------------------------------------------------------------- 
resource "azurerm_storage_account" "sa" {
  for_each                 = var.storage_accounts
  name                     = each.key
  account_tier             = each.value["account_tier"]
  account_replication_type = each.value["account_replication_type"]
  account_kind             = each.value["account_kind"]
  resource_group_name      = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  location                 = var.location

  share_properties {
    smb {
      multichannel_enabled     = each.value["multichannel_enabled"]
    }
  }

  # In order to do deny we would need Appgate and GitHub IP's 
  network_rules {
    default_action = each.value["network_default_action"]
    ip_rules       = each.value["network_ip_rules"]
  }

  dynamic "azure_files_authentication" {
    for_each = each.value.azure_files_authentication[*]
    content {
      directory_type = azure_files_authentication.value["directory_type"]
    
      dynamic "active_directory" {
        for_each = azure_files_authentication.value.active_directory[*]
        content {
          domain_guid         = active_directory.value.domain_guid
          domain_name         = active_directory.value.domain_name
          domain_sid          = active_directory.value.domain_sid
          forest_name         = active_directory.value.forest_name
          netbios_domain_name = active_directory.value.netbios_domain_name
          storage_sid         = active_directory.value.storage_sid
        }
      }
    }
  }
}

resource "azurerm_storage_container" "container" {
  for_each              = var.sa_containers
  name                  = each.key
  storage_account_name  = azurerm_storage_account.sa[each.value.storage_account_name].name
  container_access_type = each.value["container_access_type"]
}

resource "azurerm_storage_share" "file_share" {
  for_each             = var.file_shares
  storage_account_name = azurerm_storage_account.sa[each.value.storage_account_name].name
  name                 = each.key
  quota                = each.value["quota"]
  enabled_protocol     = each.value["enabled_protocol"]
}

resource "azurerm_role_assignment" "sa_role_assignment" {
  for_each             = var.sa_role_assignments
  name                 = each.key
  scope                = azurerm_storage_account.sa[each.value.storage_account_name].id
  role_definition_name = each.value["role_definition_name"]
  principal_id         = var.spn_required == true ? azuread_service_principal.service_principal[each.value.service_principal_display_name].object_id : each.value.service_principal_object_id
}

#------------------------------------------------------------------------------------------- 
# Private Endpoints
#------------------------------------------------------------------------------------------- 
resource "azurerm_private_endpoint" "storage_private_endpoint" {
  for_each            = var.storage_private_endpoints
  name                = each.key
  subnet_id           = each.value["subnet_id"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name

  private_dns_zone_group {
    name                 = each.value["private_dns_zone_group_name"]
    private_dns_zone_ids = each.value["private_dns_zone_ids"]
  }

  private_service_connection {
    name                           = each.value["private_service_connection_name"]
    private_connection_resource_id = azurerm_storage_account.sa[each.value.storage_account_name].id
    subresource_names              = each.value["subresource_names"]
    is_manual_connection           = false
  }
}
