terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraformo7odvr3icext3gp"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
