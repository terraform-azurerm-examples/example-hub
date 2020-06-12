resource "azurerm_recovery_services_vault" "hub" {
  name                = "${var.hub}-${random_string.hub.result}"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags

  sku                 = "Standard"
  soft_delete_enabled = true
}

resource "azurerm_backup_policy_vm" "default" {
  name                = "default"
  resource_group_name = azurerm_resource_group.hub.name
  recovery_vault_name = azurerm_recovery_services_vault.hub.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 14 //Between 1 & 9999
  }

  retention_weekly {
    count    = 13
    weekdays = ["Wednesday", "Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }

  retention_yearly {
    count    = 3
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}

output "recovery_services_vault" {
  value = azurerm_recovery_services_vault.hub
}

output "default_vm_backup_policy" {
  value = azurerm_backup_policy_vm.default
}
