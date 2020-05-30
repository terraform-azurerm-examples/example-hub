tenant_id       = "f246eeb7-b820-4971-a083-9e100e084ed0"
subscription_id = "2d31be49-d959-4415-bb65-8aec2c90ba62"
client_id       = "9306c4f0-3049-415c-84fd-2e0e6c416c78"
client_secret   = "Using Key Vault Secret: client-secret"

hub                    = "test-hub"
hub_vnet_address_space = ["172.16.0.0/24"]

location = "West Europe"

tags = {
  owner         = "Richard Cheney"
  business_unit = "Citadel"
  costcode      = 314159
  downtime      = "03:30 - 04:30"
  env           = "training"
  enforce       = false
}

ssh_public_keys = [
  { username = "ubuntu", ssh_public_key_file = "~/.ssh/id_rsa.pub" }
]
