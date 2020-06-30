resource "azurerm_resource_group" "hub_management_vms" {
  name     = "${var.hub}-management-vms"
  location = var.location
  tags     = var.tags
}

locals {
  vm_defaults = {
    resource_group_name  = azurerm_resource_group.hub_management_vms.name
    location             = azurerm_resource_group.hub_management_vms.location
    tags                 = azurerm_resource_group.hub_management_vms.tags
    admin_username       = "ubuntu"
    admin_ssh_public_key = azurerm_key_vault_secret.ssh_pub_key["ubuntu"].value
    additional_ssh_keys  = []
    vm_size              = "Standard_B1ls"
    storage_account_type = "Standard_LRS"
    identity_id          = azurerm_user_assigned_identity.hub.id
    subnet_id            = azurerm_subnet.SharedServices.id
    boot_diagnostics_uri = azurerm_storage_account.boot_diagnostics.primary_blob_endpoint
  }
}

//======================================================

module "jumpbox" {
  source = "github.com/terraform-azurerm-modules/terraform-azurerm-linux-vm?ref=v0.2.1"
  // source   = "../../../modules/vm"
  defaults = local.vm_defaults

  name            = "jumpbox"
  source_image_id = data.azurerm_image.ubuntu_18_04.id
  vm_size         = "Standard_B1ls"
}

//======================================================

module "dc" {
  source = "github.com/terraform-azurerm-modules/terraform-azurerm-linux-vm?ref=v0.2.1"
  // source   = "../../../modules/vm"
  defaults = local.vm_defaults

  availability_set_name = "dc"
  names                 = ["dc-01", "dc-02"]
  source_image_id       = data.azurerm_shared_image.ubuntu_18_04.id
  subnet_id             = azurerm_subnet.DomainControllers.id
}

//======================================================

module "cfgmgmt_lb" {
  source = "github.com/terraform-azurerm-modules/terraform-azurerm-load-balancer?ref=v0.2.1"
  // source   = "../../../modules/lb"
  defaults = local.vm_defaults

  name = "cfgmgmt"

  load_balancer_rules = [{
    protocol      = "Tcp",
    frontend_port = 22,
    backend_port  = 22
    },
    {
      protocol      = "Tcp",
      frontend_port = 8443,
      backend_port  = 443
    }
  ]
}

module "cfgmgmt" {
  source = "github.com/terraform-azurerm-modules/terraform-azurerm-linux-vm?ref=v0.2.1"
  // source   = "../../../modules/vm"
  defaults = local.vm_defaults

  availability_set_name               = "cfgmgmt"
  names                               = ["cfgmgmt-01", "cfgmgmt-02"]
  source_image_id                     = data.azurerm_image.ubuntu_18_04.id
  load_balancer_backend_address_pools = [module.cfgmgmt_lb.load_balancer_backend_address_pool]
}

//======================================================

module "testbed_lb" {
  source = "github.com/terraform-azurerm-modules/terraform-azurerm-load-balancer?ref=v0.2.1"
  // source   = "../../../modules/lb"
  defaults = local.vm_defaults
  name     = "testbed"
}

module "testbed_vmss" {
  source = "github.com/terraform-azurerm-modules/terraform-azurerm-linux-vmss?ref=v0.2.1"
  // source   = "../../../modules/vmss"
  defaults = local.vm_defaults

  name                                   = "testbed"
  instances                              = 3
  source_image_id                        = data.azurerm_image.ubuntu_18_04.id
  load_balancer_backend_address_pool_ids = [module.testbed_lb.load_balancer_backend_address_pool.id]
}

//======================================================
