[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $ServicePrincipalTenant,

    [Parameter(Mandatory=$true)]
    [String]
    $ServicePrincipalAppId,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $ServicePrincipalPassword
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

Write-Information "Signing into Azure as Service Principal..."

az login `
    --service-principal `
    --tenant    $ServicePrincipalTenant `
    --username  $ServicePrincipalAppId `
    --password  $(ConvertFrom-SecureString -SecureString $ServicePrincipalPassword -AsPlainText)

if (!$?) {
    Write-Error "Failed to login as service principal."
}

Write-Information "Sign in completed successfully!"
