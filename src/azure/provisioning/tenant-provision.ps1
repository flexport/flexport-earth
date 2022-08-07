$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ../releasables/dependencies/dependency-manager.ps1

$AzureTenantId = (az account show | ConvertFrom-Json).HomeTenantId

Write-Information "Provisioning Deployer role in Tetant $AzureTenantId..."

$Parameters = '{\"azureTenantId\":{\"value\":\"' + $AzureTenantId + '\"}}'

az deployment mg create `
    --location              WestUS `
    --management-group-id   $AzureTenantId `
    --template-file         deployer-role.bicep `
    --parameters            $Parameters
