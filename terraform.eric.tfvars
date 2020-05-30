tenant_id       = "1d23ed27-6f11-4050-874b-7e04ca535809"
subscription_id = "9404e91c-cf5a-405b-9c2f-32c06896519e"
client_id       = "f8fae724-605e-4d1d-b8c5-c4b1b46a60e5"
client_secret   = "35b58cf7-dff3-4baa-9b99-4f05acfcafa0"

hub                    = "sspp-hub"
hub_vnet_address_space = ["172.16.0.0/24"]

location = "West Europe"

tags = {
  owner         = "Eric Wolfram"
  business_unit = "ITSS"
  costcode      = 123456
  downtime      = "03:30 - 04:30"
  env           = "SSPP"
  enforce       = false
}

ssh_public_keys = [
  { username = "ubuntu", ssh_public_key_file = "~/.ssh/id_rsa.pub" }
]
