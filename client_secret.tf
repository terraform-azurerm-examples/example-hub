// Aliased azurerm provder to access the key vault using the user's RBAC permissions

provider "azurerm" {
  // Uses the Azure CLI token (or env vars) unless managed identity is used
  features {}
  alias   = "backend"
  use_msi = false
}

// The service principal's password.
// az keyvault secret show --vault-name terraformtozeaufchdnfx4f --name client-secret --output tsv --query value

data "azurerm_key_vault_secret" "client_secret" {
  provider     = azurerm.backend
  key_vault_id = "/subscriptions/2d31be49-d959-4415-bb65-8aec2c90ba62/resourceGroups/terraform/providers/Microsoft.KeyVault/vaults/terraformtozeaufchdnfx4f"
  name         = "client-secret"
}