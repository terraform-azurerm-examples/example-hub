provider "azurerm" {
  version             = "~> 2.15"
  storage_use_azuread = true

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  // Delete all commented lines if using  Azure CLI token: https://www.terraform.io/docs/providers/azurerm/guides/azure_cli.html

  // Set to true if using Managed Identity: https://www.terraform.io/docs/providers/azurerm/guides/managed_service_identity.html
  use_msi = false

  // Set if using Service Principal: https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html
  // tenant_id       = ""
  // subscription_id = ""
  // client_id       = ""
  // client_secret   = ""
  // (Or use environment variables if running in a CI/CD pipeline.)

  // Recommended: Use the outputs from https://github.com/terraform-azurerm-modules/terraform-bootstrap
}
