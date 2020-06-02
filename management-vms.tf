locals {
  set_defaults = {
    resource_group_name = azurerm_resource_group.hub.name
    location            = azurerm_resource_group.hub.location
    tags                = azurerm_resource_group.hub.tags
    availability_set    = true
    load_balancer       = true
    subnet_id           = azurerm_subnet.SharedServices.id
  }

  vm_defaults = {
    resource_group_name  = azurerm_resource_group.hub.name
    location             = azurerm_resource_group.hub.location
    tags                 = azurerm_resource_group.hub.tags
    admin_username       = "ubuntu"
    admin_ssh_public_key = azurerm_key_vault_secret.ssh_pub_key["ubuntu"].value
    additional_ssh_keys  = []
    vm_size              = "Standard_B1ls"
    storage_account_type = "Standard_LRS"
    subnet_id            = azurerm_subnet.SharedServices.id
    boot_diagnostics_uri = azurerm_storage_account.boot_diagnostics.primary_blob_endpoint
  }
}

module "jumpbox" {
  source   = "github.com/terraform-azurerm-modules/terraform-azurerm-linux-vm?ref=v0.1"
  defaults = local.vm_defaults

  name            = "jumpbox"
  source_image_id = data.azurerm_image.ubuntu_18_04.id
}


module "testbed_set" {
  source   = "github.com/terraform-azurerm-modules/terraform-azurerm-set?ref=v0.1"
  defaults = local.set_defaults

  name = "testbed"
}

module "testbed" {
  source   = "github.com/terraform-azurerm-modules/terraform-azurerm-linux-vm?ref=v0.1"
  defaults = local.vm_defaults

  module_depends_on = [module.testbed_set]
  attachType        = "All"
  attach            = module.testbed_set.set_ids

  names           = ["testbed-a", "testbed-b", "testbed-c"]
  source_image_id = data.azurerm_image.ubuntu_18_04.id
}

module "minimalargs" {
  source              = "github.com/terraform-azurerm-modules/terraform-azurerm-linux-vm?ref=v0.1"
  resource_group_name = azurerm_resource_group.hub.name

  name                 = "minimalargs"
  source_image_id      = data.azurerm_shared_image.ubuntu_18_04.id
  subnet_id            = azurerm_subnet.SharedServices.id
  boot_diagnostics_uri = azurerm_storage_account.boot_diagnostics.primary_blob_endpoint
}
