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

Write-Information "- Provisioning Deployer role..."

az deployment sub create `
    --location WestUS `
    --template-file azure-deployer-role.bicep

Write-Information "- Provisioning $SubscriptionDeploymentServicePricipalName service principle..."
az ad sp create-for-rbac `
    --name $SubscriptionDeploymentServicePricipalName `
    --role "deployer" `
    --scopes "/subscriptions/$SubscriptionId"

Write-Information ""
Write-Information "If $AzureSubscriptionName is your own personal Azure subscription, then save the above Service Principal details in a secure location on your local machine."
Write-Information ""
Write-Information "If $AzureSubscriptionName is an Azure DevOps managed environment, then save the above Service Principal details as a Service Connection here: https://matthew-thomas.visualstudio.com/Earth/_settings/adminservices"
