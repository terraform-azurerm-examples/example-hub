resource "azurerm_public_ip" "vpngw" {
  name                = "vpngw-pip"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags

  allocation_method = "Dynamic"
  domain_name_label = "${var.hub}-${random_string.hub.result}"
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


  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client ? [1] : []

    content {
      address_space = var.vpn_client_address_space

      vpn_client_protocols = ["OpenVPN"]

      root_certificate {
        name             = var.vpn_client_cert_name
        public_cert_data = file(var.vpn_client_cert)
      }
    }
  }
}

output "vpngw" {
  value = azurerm_virtual_network_gateway.vpngw
}

output "vpngw-pip" {
  value = azurerm_public_ip.vpngw
}

output "vpn_client" {
  value = {
    address_space        = ["192.168.76.0/24"]
    vpn_client_protocols = ["OpenVPN"]
    authentication_type  = "Azure Active Directory"
    azure_active_directory = {
      tenant   = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/"
      audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
      issuer   = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/"
    }
  }
}
