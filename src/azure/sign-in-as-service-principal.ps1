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

# Load Global Development Settings
$GlobalDevelopmentSettings = Get-Content 'dev/development-config.json' | ConvertFrom-Json
$CacheDirectory = $GlobalDevelopmentSettings.CacheDirectory

$SubscriptionDeploymentServicePricipalName = "$AzureSubscriptionName-earth-deployer".ToLower()

$CredsPath = "$CacheDirectory/azure/creds/${SubscriptionDeploymentServicePricipalName}.json"

if (-Not (Test-Path $CredsPath)) {
    Write-Error "Service Principal cached credentials not found at $.CredsPath. Please run ./azure/subscription-provision.ps1 to create a Service Principal, which will cache the credentials for use."
}

$ServicePrincipalCredentials = Get-Content -Path $CredsPath | ConvertFrom-Json

az login `
    --service-principal `
    -u $ServicePrincipalCredentials.appId `
    -p $ServicePrincipalCredentials.password `
    --tenant $ServicePrincipalCredentials.tenant
