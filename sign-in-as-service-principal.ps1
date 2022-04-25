$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$CredsPath = "./.cache/azure-service-principal-creds.json"

if (-Not (Test-Path $CredsPath)) {
    Write-Error "Service Principal cached credentials not found at $.CredsPath."
    Write-Error "Please run ./provision-azure-subscription.ps1 to create a Service Principal, which will cache the credentials for use."
}

$ServicePrincipalCredentials = Get-Content -Path ./.cache/azure-service-principal-creds.json | ConvertFrom-Json

az login `
    --service-principal `
    -u $ServicePrincipalCredentials.appId `
    -p $ServicePrincipalCredentials.password `
    --tenant $ServicePrincipalCredentials.tenant
