// Note that some of the .tf files also have variable and output blocks to make them individually complete


variable "hub" {
  type        = string
  description = "Used for both the vnet and the resource group, and to prefix resources."
  default     = "hub"
}


variable "hub_vnet_address_space" {
  description = "List of address spaces for the virtual network. One /24 address space is expected."
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "dns_servers" {
  description = "Optional list of DNS server IP addresses."
  type        = list(string)
  default     = null
}

// -----------------------------------------------------------

variable "tenant_id" {
  description = "The AAD tenant guid."
  type        = string
}

variable "subscription_id" {
  description = "The subscription guid."
  type        = string
}

variable "client_id" {
  description = "The application id for the service principal."
  type        = string
}

variable "client_secret" {
  type        = string
  description = "The password for the service principal."
  default     = ""
}

variable "location" {
  default = "West Europe"
}

variable "tags" {
  type = object({
    owner         = string
    business_unit = string
    costcode      = number
    downtime      = string
    env           = string
    enforce       = bool
  })
}
