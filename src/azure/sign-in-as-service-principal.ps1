[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [SecureString]
    $ServicePrincipalCredentialsTenant,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $ServicePrincipalCredentialsAppId,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $ServicePrincipalCredentialsPassword
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

Write-Information "Signing into Azure as Service Principal..."

az login `
    --service-principal `
    --tenant    $(ConvertFrom-SecureString -SecureString $ServicePrincipalCredentialsTenant   -AsPlainText) `
    --username  $(ConvertFrom-SecureString -SecureString $ServicePrincipalCredentialsAppId    -AsPlainText) `
    --password  $(ConvertFrom-SecureString -SecureString $ServicePrincipalCredentialsPassword -AsPlainText)

if (!$?) {
    Write-Error "Failed to login as service principal."
}

Write-Information "Sign in completed successfully!"
