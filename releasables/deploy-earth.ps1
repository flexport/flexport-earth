[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

# Load common configuration values
. ./earth-config.ps1

$Parameters = '{\"earthFrontendResourceGroupName\":{\"value\":\"' + $EarthFrontendResourceGroupName + '\"}, \"resourceGroupLocation\":{\"value\":\"' + $EarthFrontendResourceGroupLocation + '\"}}'

az `
    deployment sub create `
    --mode Complete `
    --location $EarthFrontendResourceGroupLocation `
    --template-file ./frontend/earth-frontend.bicep `
    --parameters $Parameters

if (!$?) {
    Write-Error "Resource group deployment failed."
    Exit 1
}

az `
    deployment group create `
    --mode Complete `
    --resource-group $EarthFrontendResourceGroupName `
    --template-file ./frontend/cdn/main.bicep

if (!$?) {
    Write-Error "CDN deployment failed."
    Exit 1
}

az `
    deployment sub create `
    --mode Complete `
    --location $EarthFrontendResourceGroupLocation `
    --template-file azure-subscription/subscription-budget.bicep `
    --parameters @azure-subscription/subscription-budget.parameters.json

if (!$?) {
    Write-Error "Budget deployment failed."
    Exit 1
}
