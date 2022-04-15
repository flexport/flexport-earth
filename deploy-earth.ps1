# This file tested with azure-cli 2.33.1
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
#     [Parameter(Mandatory=$true)]
#     [String]
#     $ServicePrincipalUsername,
#     [Parameter(Mandatory=$true)]
#     [String]
#     $ServicePrincipalPassword,
#     [Parameter(Mandatory=$true)]
#     [String]
#     $ServicePrincipalTenant
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# az login --service-principal -u $ServicePrincipalUsername -p $ServicePrincipalPassword --tenant $ServicePrincipalTenant

$Parameters = '{\"environmentName\":{\"value\":\"' + $EnvironmentName + '\"}, \"resourceGroupLocation\":{\"value\":\"WestUS\"}}'

az `
    deployment sub create `
    --location WestUS `
    --template-file create-resource-group.bicep `
    --parameters $Parameters
