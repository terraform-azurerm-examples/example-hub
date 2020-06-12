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

  vpn_client_configuration {
    address_space = ["192.168.76.0/24"]

    vpn_client_protocols = ["OpenVPN"]

    root_certificate {
      name = "SelfSignedCertificate"

      public_cert_data = <<EOF
MIIC5jCCAc6gAwIBAgIIXngZ8AziwMkwDQYJKoZIhvcNAQELBQAwETEPMA0GA1UE
AxMGVlBOIENBMB4XDTIwMDYxMDA5NDc1MloXDTIzMDYxMDA5NDc1MlowETEPMA0G
A1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4DY2
tny5wr6XaWwuql1iKnsBgyh0ICqFoNM7c10GAdSsDVgDcsWNKksWjCUiashH3Gm1
CwfYvkjq49ynm0lbKzfPPY3Z9hN0Lly2UF3+mHzwTi+vq8bER7tpMRfyIDgMvUDH
Da0pdvuJszKZXSJzvzPvzDSYvkjQWtf2kJpjQku2AZ57VliOsweJzbaTE9EoDoWa
mdRHhJtUu1M60TAkfU/FjGnMBxwHrwbErDChK2RSl9npQ9fwK8RJlkRNeP+vejWD
lKpN96WKWaeJ8cYNDk1PpIfIruvPUFJL0ipfTEjpIZEVqV/jeRasyYOCVaAW4e9W
agq/GAO+51/yEhI1EQIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB
/wQEAwIBBjAdBgNVHQ4EFgQUJu3ZG5wU2L6+x+pnOqS71NrAM5EwDQYJKoZIhvcN
AQELBQADggEBAGfsTMTTvCZm1w6MVrfNVMtMcm2Jh5qbvU1ZTnr2IBbbCr5Qn4/I
NHfMuZ+8R8aWwRyHDZVGLNFvvJ5VnIJGLBPaJIVEWUDKdzXVOazQHox+6ZMTr0zw
vmzJQfaAkdJM3VHI8p0p95JtpA+q3uW+JL7c28JRktkBsrUh6/r/3BvaGDfPRrYP
n1krebxlYj2mZxoHrAD4rI0axI3PoXdxZR9ozkWHhSqy3cnxUXUCGpPCAN1rMWT0
e6RBznbhefcXORvCu9ThpEvJvJSrvUoAmEnGwoL7srdaEh5a1KxL6PHk4PXlT8vA
FE/lDx61NKox4XK4y4t3gHQVSAXjOa05Z50=
EOF
    }
  }
}

output "vpngw" {
  value = azurerm_virtual_network_gateway.vpngw
}

output "vpngw-pip" {
  value = azurerm_public_ip.vpngw
}

output "vpngw-client" {
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
