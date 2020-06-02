resource "azurerm_public_ip" "vpngw" {
  name                = "vpngw-pip"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "vpngw"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags

  type       = "Vpn"
  vpn_type   = "RouteBased"
  enable_bgp = true
  sku        = "VpnGw2"
  generation = "Generation2"

  ip_configuration {
    name                          = "vpngwIpConfig"
    public_ip_address_id          = azurerm_public_ip.vpngw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.GatewaySubnet.id
  }
}

output "vpngw" {
  value = azurerm_virtual_network_gateway.vpngw
}

output "vpngw-pip" {
  value = azurerm_public_ip.vpngw
}
