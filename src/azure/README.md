## Provisioning Azure for Earth

### Login

Login as the Azure Account Owner:

    az login

If you work with multiple subscriptions, be sure to set the correct default subscription that the Earth scripts should use:

    az account set --subscription <subscription name here>

### Provision a new Azure Tenant

    ./azure/tenant-provision.ps1

### Provision a new Azure Subscription

    ./azure/subscription-provision.ps1 -AzureSubscriptionName <subscription name here>

## Deprovisioning

You can also remove the Earth setup from Azure.

## Deprovision an Azure Subscription

    ./azure/subscription-deprovision.ps1 -AzureSubscriptionName <subscription name here>

## Deprovision an Azure Tenant

    ./azure/tenant-deprovision.ps1
