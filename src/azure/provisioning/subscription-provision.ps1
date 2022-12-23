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
. ./src/releasables/dependencies/dependency-manager.ps1

$SubscriptionDeploymentServicePricipalName = "${AzureSubscriptionName}-earth-deployer".ToLower()

$Result = az account show --subscription $AzureSubscriptionName

if (!$?) {
    Write-Error "Failed to show the account. Run 'az login' and then try again."
}

$SubscriptionId = ($Result | ConvertFrom-Json).id

Write-Information "Provisioning subscription $AzureSubscriptionName (id: $SubscriptionId) ..."
Write-Information "- Provisioning $SubscriptionDeploymentServicePricipalName service principle..."

$ServicePrincipalCredentials = az ad sp create-for-rbac `
    --name      $SubscriptionDeploymentServicePricipalName `
    --role      "Deployer" `
    --scopes    "/subscriptions/$SubscriptionId"

if (!$?) {
    Write-Error "Failed to create the Service Principal!"
}

# Load Global Development Settings
$GlobalDevelopmentSettings = Get-Content 'dev/development-config.json' | ConvertFrom-Json
$CacheDirectory = $GlobalDevelopmentSettings.CachedAzureCredsDirectory

if (-Not (Test-Path $CacheDirectory)) {
    New-Item -ItemType Directory -Path $CacheDirectory
}

$CredsPath = "$CacheDirectory/${SubscriptionDeploymentServicePricipalName}.json"
$ServicePrincipalCredentials | Out-File -FilePath $CredsPath

Write-Information ""
Write-Information "Service Principal created! Credentials have been stored in $CredsPath"
Write-Information ""
Write-Information "If $AzureSubscriptionName is an Azure DevOps managed environment, then save the above Service Principal details as a Service Connection here: https://dev.azure.com/flexport-earth/Earth/_settings/adminservices"
