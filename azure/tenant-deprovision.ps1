$ErrorActionPreference = "Stop"
$InformationPreference = 'Continue' 

$AzureTenantId = (az account show | ConvertFrom-Json).HomeTenantId

Write-Information "Deprovisioning Azure tenant $AzureTenantId ..."

Write-Information "Deleting Deployer custom role..."

az role definition delete `
    --name "Deployer" `
    --scope "/providers/Microsoft.Management/managementGroups/$AzureTenantId"

Write-Information "Deployer custom role deleted."