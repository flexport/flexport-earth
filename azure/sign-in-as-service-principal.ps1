[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $AzureSubscriptionName
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ../releasables/dependencies/dependency-manager.ps1

$SubscriptionDeploymentServicePricipalName = "$AzureSubscriptionName-earth-deployer".ToLower()

$CredsPath = "../.cache/azure/creds/${SubscriptionDeploymentServicePricipalName}.json"

if (-Not (Test-Path $CredsPath)) {
    Write-Error "Service Principal cached credentials not found at $.CredsPath."
    Write-Error "Please run ./provision-azure-subscription.ps1 to create a Service Principal, which will cache the credentials for use."
}

$ServicePrincipalCredentials = Get-Content -Path $CredsPath | ConvertFrom-Json

az login `
    --service-principal `
    -u $ServicePrincipalCredentials.appId `
    -p $ServicePrincipalCredentials.password `
    --tenant $ServicePrincipalCredentials.tenant
