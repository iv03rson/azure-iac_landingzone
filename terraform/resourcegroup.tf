resource "azurerm_resource_group" "resource_group" {
  for_each = var.resource_groups
  name     = each.key
  location = var.location
}

# use this role assignment block to assign roles to the resource group created above
resource "azurerm_role_assignment" "rg_role_assignment" {
  for_each             = var.rg_role_assignments
  name                 = each.key
  scope                = azurerm_resource_group.resource_group[each.value.resource_group_name].id
  role_definition_name = each.value["role_definition_name"]
  principal_id         = each.value["principal_id"]
  }

  resource "azurerm_role_assignment" "subscription_role_assignment" {
  for_each             = var.subscription_role_assignments
  name                 = each.key
  scope                = var.subscription_scope
  role_definition_name = each.value["role_definition_name"]
  principal_id         = each.value["principal_id"]
  }