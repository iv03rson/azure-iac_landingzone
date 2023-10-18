#------------------------------------------------------------------------------------------- 
# Storage Diagnostic settings
#------------------------------------------------------------------------------------------- 
resource "azurerm_monitor_diagnostic_setting" "sa" {
  for_each                       = var.storage_account_diagnostics
  name                           = each.key
  target_resource_id             = "${azurerm_storage_account.sa[each.value.storage_account_name].id}/${each.value.storage_account_type}"
  eventhub_name                  = each.value["eventhub_name"]
  eventhub_authorization_rule_id = each.value["eventhub_authorization_rule_id"]
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace[each.value.log_analytics_workspace].id

  log {
    category = "StorageRead"
    enabled  = each.value["enable_storageread_log"]

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  log {
    category = "StorageWrite"
    enabled  = each.value["enable_storagewrite_log"]

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  log {
    category = "StorageDelete"
    enabled  = each.value["enable_storagedelete_log"]

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  metric {
    category = "Capacity"
    enabled  = each.value["enable_capacity_metric"]

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  metric {
    category = "Transaction"
    enabled  = each.value["enable_transaction_metric"]

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}

#------------------------------------------------------------------------------------------- 
# Key vault Diagnostic settings
#------------------------------------------------------------------------------------------- 
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  for_each                       = var.key_vault_diagnostics
  name                           = each.key
  target_resource_id             = azurerm_key_vault.key_vault[each.value.key_vault_name].id
  eventhub_name                  = each.value["eventhub_name"]
  eventhub_authorization_rule_id = each.value["eventhub_authorization_rule_id"]
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace[each.value.log_analytics_workspace].id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "AuditEvent"
    enabled  = each.value["enable_auditevent_log"]

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = each.value["enable_azurepolicyevaluationdetails_log"]

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
