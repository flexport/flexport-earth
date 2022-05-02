[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $AzureSubscriptionName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

$SubscriptionDeploymentServicePricipalName = "${AzureSubscriptionName}-earth-deployer".ToLower()

$SubscriptionId = (az account show --subscription $AzureSubscriptionName | ConvertFrom-Json).id

Write-Information "Provisioning subscription $AzureSubscriptionName (id: $SubscriptionId) ..."
Write-Information "- Provisioning $SubscriptionDeploymentServicePricipalName service principle..."

$ServicePrincipalCredentials = az ad sp create-for-rbac `
    --name $SubscriptionDeploymentServicePricipalName `
    --role "Deployer" `
    --scopes "/subscriptions/$SubscriptionId"

# Load Global Development Settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json
$CacheDirectory = $GlobalDevelopmentSettings.CacheDirectory

$LocalCacheFolder = "$CacheDirectory/azure/creds"

if (-Not (Test-Path $LocalCacheFolder)) {
    New-Item -ItemType Directory -Path $LocalCacheFolder
}

$CredsPath = "$LocalCacheFolder/${SubscriptionDeploymentServicePricipalName}.json"
$ServicePrincipalCredentials | Out-File -FilePath $CredsPath

Write-Information ""
Write-Information "Service Principal created! Credentials have been stored in $CredsPath"
Write-Information ""
Write-Information "If $AzureSubscriptionName is an Azure DevOps managed environment, then save the above Service Principal details as a Service Connection here: https://matthew-thomas.visualstudio.com/Earth/_settings/adminservices"
