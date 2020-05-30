locals {
  vm_defaults = {
    module_depends_on   = [azurerm_subnet.SharedServices.id]
    resource_group_name = azurerm_resource_group.hub.name
    location            = azurerm_resource_group.hub.location
    tags                = azurerm_resource_group.hub.tags

    key_vault_id         = azurerm_key_vault.hub.id
    boot_diagnostics_uri = azurerm_storage_account.boot_diagnostics.primary_blob_endpoint

    admin_username       = "ubuntu"
    admin_ssh_public_key = azurerm_key_vault_secret.ssh_pub_key["ubuntu"].value
    additional_ssh_keys  = []
    subnet_id            = azurerm_subnet.SharedServices.id
    vm_size              = "Standard_B1ls"
    storage_account_type = "Standard_LRS"
  }
}

module "jumpbox" {
  source          = "../../modules/terraform-azurerm-linux-vm/"
  defaults        = local.vm_defaults
  name            = "jumpbox"
  source_image_id = data.azurerm_image.ubuntu_18_04.id
}
