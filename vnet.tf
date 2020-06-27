resource "azurerm_virtual_network" "hub" {
  name                = var.hub
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags
  address_space       = var.hub_vnet_address_space
}

resource "azurerm_subnet" "SharedServices" {
  depends_on           = [azurerm_virtual_network.hub]
  name                 = "SharedServices"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [
    cidrsubnet(azurerm_virtual_network.hub.address_space[0], 2, 0),
    // cidrsubnet(azurerm_virtual_network.hub.address_space[0], 3, 2)
  ]
}

resource "azurerm_subnet" "DomainControllers" {
  depends_on           = [azurerm_subnet.SharedServices]
  name                 = "DomainControllers"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 5, 12)]
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  depends_on           = [azurerm_subnet.DomainControllers]
  name                 = "AzureFirewallSubnet" # Minimum /26
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 2, 2)]
}

resource "azurerm_subnet" "AzureBastionSubnet" {
  depends_on           = [azurerm_subnet.AzureFirewallSubnet]
  name                 = "AzureBastionSubnet" # Minimum /27
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 3, 6)]
}

resource "azurerm_subnet" "GatewaySubnet" {
  depends_on           = [azurerm_subnet.AzureBastionSubnet]
  name                 = "GatewaySubnet" # Minimum /27
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 3, 7)]
}

output "vnet" {
  value = azurerm_virtual_network.hub
}

output "subnet" {
  value = {
    "SharedServices"      = azurerm_subnet.SharedServices
    "DomainControllers"   = azurerm_subnet.DomainControllers
    "AzureFirewallSubnet" = azurerm_subnet.AzureFirewallSubnet
    "AzureBastionSubnet"  = azurerm_subnet.AzureBastionSubnet
    "GatewaySubnet"       = azurerm_subnet.GatewaySubnet
  }
}