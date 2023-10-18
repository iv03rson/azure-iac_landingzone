#------------------------------------------------------------------------------------------- 
# Log analytics workspace
#------------------------------------------------------------------------------------------- 
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  for_each                   = var.log_analytics_workspaces
  name                       = each.key
  resource_group_name        = azurerm_resource_group.resource_group[each.value.resource_group_name].name

  sku                        = each.value["log_workspace_sku"]
  retention_in_days          = each.value["log_workspace_retention"]
  internet_ingestion_enabled = each.value["internet_ingestion_enabled"]
  internet_query_enabled     = each.value["internet_query_enabled"]
  location                   = var.location
}

resource "azurerm_role_assignment" "log_analytics_workspace_role_assignment" {
  for_each             = var.log_analytics_workspace_role_assignments
  name                 = each.key
  scope                = azurerm_log_analytics_workspace.log_analytics_workspace[each.value.log_analytics_workspace].id
  role_definition_name = each.value["role_definition_name"]
  principal_id         = each.value["principal_id"]
}