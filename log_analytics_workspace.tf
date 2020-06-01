resource "azurerm_log_analytics_workspace" "hub" {
  name                = substr(replace("${var.hub}-${random_string.hub.result}", "/[^0-9A-Za-z\\-]+/", ""), 0, 24) // 3-24 lowercase alnum only
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags

  sku               = "PerGB2018"
  retention_in_days = 30 // Max 730
}

output "log_analytics_workspace" {
  value = azurerm_log_analytics_workspace.hub
}