[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $AzureSubscriptionName
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$SubscriptionDeploymentServicePricipalName = "earth-deployer"

$SubscriptionId = (az account show --subscription $AzureSubscriptionName | ConvertFrom-Json).id

Write-Information "Provisioning subscription $AzureSubscriptionName (id: $SubscriptionId) ..."
Write-Information "- Provisioning $SubscriptionDeploymentServicePricipalName service principle..."

$ServicePrincipalCredentials = az ad sp create-for-rbac `
    --name $SubscriptionDeploymentServicePricipalName `
    --role "Deployer" `
    --scopes "/subscriptions/$SubscriptionId"

$LocalCacheFolder = "./.cache/azure/creds"

if (-Not (Test-Path $LocalCacheFolder)) {
    New-Item -ItemType Directory -Path $LocalCacheFolder
}

$CredFileName = "${AzureSubscriptionName}_${SubscriptionDeploymentServicePricipalName}"

$CredsPath = "$LocalCacheFolder/$CredFileName.json"
$ServicePrincipalCredentials | Out-File -FilePath $CredsPath

Write-Information ""
Write-Information "Service Principal created! Credentials have been stored in $CredsPath"
Write-Information ""
Write-Information "If $AzureSubscriptionName is an Azure DevOps managed environment, then save the above Service Principal details as a Service Connection here: https://matthew-thomas.visualstudio.com/Earth/_settings/adminservices"
