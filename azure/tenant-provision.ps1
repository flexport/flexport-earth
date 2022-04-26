$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$AzureTenantId = (az account show | ConvertFrom-Json).HomeTenantId

Write-Information "Provisioning Deployer role in Tetant $AzureTenantId..."

$Parameters = '{\"azureTenantId\":{\"value\":\"' + $AzureTenantId + '\"}}'

az deployment mg create `
    --location WestUS `
    --management-group-id $AzureTenantId `
    --template-file azure-deployer-role.bicep `
    --parameters $Parameters 
