resource "azurerm_storage_account" "boot_diagnostics" {
  name                = substr(replace(lower("${var.hub}-${random_string.hub.result}"), "/[^0-9a-z]+/", ""), 0, 24) // 3-24 lowercase alnum only
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


output "boot_diagnostics" {
  value = azurerm_storage_account.boot_diagnostics
}
