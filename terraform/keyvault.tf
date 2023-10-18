#------------------------------------------------------------------------------------------- 
# Key vault
#------------------------------------------------------------------------------------------- 
resource "azurerm_key_vault" "key_vault" {
  for_each                   = var.key_vaults
  name                       = each.key
  resource_group_name        = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  sku_name                   = each.value["sku_name"]
  tenant_id                  = var.tenant_id
  location                   = var.location
  soft_delete_retention_days = each.value["soft_delete_retention_days"]
  purge_protection_enabled   = true

  network_acls {
    default_action  = each.value["network_default_action"]
    bypass          = each.value["network_bypass"]
  }
}

resource "azurerm_key_vault_access_policy" "kv_accesspolicy" {
  tenant_id               = var.tenant_id
  for_each                = var.kv_accesspolicy
  key_vault_id            = azurerm_key_vault.key_vault[each.value.key_vault_name].id
  object_id               = var.spn_required == true ?  azuread_service_principal.service_principal[each.value.service_principal_object_id] : azuread_service_principal.service_principal[each.value.service_principal_display_name].object_id
  certificate_permissions = each.value["certificate_permissions"]
  key_permissions         = each.value["key_permissions"]
  secret_permissions      = each.value["secret_permissions"]
  storage_permissions     = each.value["storage_permissions"]
}

#------------------------------------------------------------------------------------------- 
# Private Endpoints and DNS zone links
#------------------------------------------------------------------------------------------- 
resource "azurerm_private_endpoint" "keyvault_private_endpoint" {
  for_each            = var.keyvault_private_endpoints
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
    private_connection_resource_id = azurerm_key_vault.key_vault[0].id
    subresource_names              = each.value["subresource_names"]
    is_manual_connection           = false
  }
}