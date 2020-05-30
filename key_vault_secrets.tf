variable "ssh_public_keys" {
  description = "List of usernames and public ssh keys. Will be loaded into key vault as secrets to be used by the VM modules."
  type = list(object({
    username            = string
    ssh_public_key_file = string
  }))
  default = []
}

locals {
  ssh_public_keys = {
    for object in var.ssh_public_keys :
    object.username => file(object.ssh_public_key_file)
  }
}

resource "random_pet" "example" {}

resource "azurerm_key_vault_secret" "example" {
  key_vault_id = azurerm_key_vault.hub.id
  depends_on   = [azurerm_key_vault_access_policy.service_principal]

  name         = "pet-example"
  content_type = "pet-example"
  value        = random_pet.example.id
}

resource "azurerm_key_vault_secret" "ssh_pub_key" {
  key_vault_id = azurerm_key_vault.hub.id
  depends_on   = [azurerm_key_vault_access_policy.service_principal]

  for_each = local.ssh_public_keys

  name         = "ssh-pub-key-${each.key}"
  value        = each.value
  content_type = "ssh-pub-key"
}

resource "null_resource" "ssh_pub_key_secrets_available" {
  # Any changes to these key vault secrets will trigger a sleep
  triggers = local.ssh_public_keys

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
