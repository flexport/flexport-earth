# This file tested with azure-cli 2.33.1

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $AzureSubscriptionName
)

# Enable 'Write-Information' calls to show in the console.
$InformationPreference = 'Continue' 

$SubscriptionDeploymentServicePricipalName = "earth-deployer"

$SubscriptionId = (az account show --subscription $AzureSubscriptionName | ConvertFrom-Json).id

Write-Information "Provisioning subscription $AzureSubscriptionName (id: $SubscriptionId) ..."

Write-Information "- Provisioning subscription deployment principle..."
az ad sp create-for-rbac `
    --name $SubscriptionDeploymentServicePricipalName `
    --role "contributor" `
    --scopes "/subscriptions/$SubscriptionId"
