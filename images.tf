data "azurerm_image" "ubuntu_18_04" {
  name                = "ubuntu"
  resource_group_name = "images"
}

data "azurerm_shared_image" "ubuntu_18_04" {
  name                = "ubuntuBase"
  gallery_name        = "customImages"
  resource_group_name = "images"
}