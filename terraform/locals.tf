locals {
  #resource_group_name = var.resource_group_required == true ? azurerm_resource_group.resource_group[each.value.resource_group_name].name : each.value["resource_group_name"]
}
