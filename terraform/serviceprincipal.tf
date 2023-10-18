resource "azuread_application" "application" {
  for_each     = var.applications
  display_name = each.key
  owners       = var.spn_owner
}

resource "azuread_service_principal" "service_principal" {
  for_each                     = var.service_principals
  application_id               = azuread_application.application[each.value.application_display_name].application_id
  app_role_assignment_required = false
  owners                       = var.spn_owner
}

resource "azuread_application_password" "application_password" {
  for_each              = var.application_password
  application_object_id = azuread_application.application[each.value.application_display_name].object_id
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  provider     = azurerm.foundations
  for_each     = var.key_vault_spn_secrets
  name         = each.key
  value        = azuread_application_password.application_password[each.value.password_name].value
  key_vault_id = var.key_vault_id
}

# use this role assignment block to assign roles to the service principal created above
resource "azurerm_role_assignment" "spn_role_assignment" {
  for_each             = var.spn_role_assignments
  name                 = each.key
  scope                = each.value["scope"]
  role_definition_name = each.value["role_definition_name"]
  principal_id         = var.spn_required == true ? azuread_service_principal.service_principal[each.value.service_principal_display_name].object_id : each.value.service_principal_object_id
}
