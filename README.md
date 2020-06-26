# terraform-example-hub

This is an example Terraform config creating a hub in a hub and spoke topology.

It is a work in progress and may be updated at any point.

## AzureRM Provider

You will need to create an azurerm provider file.

An example file has been provided - azurerm_provider.tf - that will use your current [Azure CLI](https://www.terraform.io/docs/providers/azurerm/guides/azure_cli.html) token by default. You can also uncomment the block to specify the GUIDs for a [service principal](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html).

Alternatively, look at the terraform-bootstrap repo as this will generate a service principal, remote state storage account and a key vault. It is intended for production environments. It will create outputs you can use:

* azurerm_provider.tf
* backend.tf
* bootstrap_secrets.tf

## terraform.tfvars

An example terraform.tfvars in included. More defaulted variables can be found in the variables.tf.

## Modularity

Against standard Terraform practice, this repo has standalone HCL files for services that include the variables, resources and outputs. For example, the bastion.tf file in the waiting_room folder can be moved up into the root to create a bastion service. This has been done to allow easy testing.

## Images

The management vm examples use modules. You don't have to use these and can use native resources or your own modules. This is not prescriptive.

The current VM modules use custom images. If you wish to create your own example custom images and publish them to a Shared Image Gallery then you can use the <https://github.com/richeney/packer>.

If you want to include the Azure Bastion serv