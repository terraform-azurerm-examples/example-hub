# Azure Context

## Introduction

It is important to ensure you are are logged in with the correct security principal and that you are in the correct subscription.

This is called context for short.

## Show Context

Get the context of your current session:

```bash
az account show --output jsonc
```

Check:

* User principal name and type
* tenantId
* id (which is the subscriptionId)

## Changing User

An AAD security principal is either a standard user principal, or a service principal. Managed identity is a variant of a service principal.

* Use `az login` to login as a different security principal.
* Use the `--tenant` switch to login as a guest user into another tenant.
* Use the `--service-principal` or `--identity` switches if logging in as a service principal or a managed identity.

Use `az login --help` to view usage and examples.

## Listing subscriptions

```bash
az account list --output table
```

## Changing subscription

```bash
az account set --subscription <subscriptionId>
```

> You can also use the name of the subscription as a string.

Note that this will become your new default when you log in as the current user.

## Aliases

If you are constantly switching between subscriptions then consider adding an alias to your .bashrc file.

For example:

```bash
alias vs='az account set --subscription 2d31be49-d959-4415-bb65-8aec2c90ba62; az account show --output yamlc'
```
