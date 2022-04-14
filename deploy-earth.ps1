# This file tested with azure-cli 2.33.1
# [CmdletBinding()]
# param (
#     [Parameter(Mandatory=$true)]
#     [String]
#     $ServicePrincipalUsername,
#     [Parameter(Mandatory=$true)]
#     [String]
#     $ServicePrincipalPassword,
#     [Parameter(Mandatory=$true)]
#     [String]
#     $ServicePrincipalTenant
# )

$ErrorActionPreference = "Stop"

# az login --service-principal -u $ServicePrincipalUsername -p $ServicePrincipalPassword --tenant $ServicePrincipalTenant

az `
    deployment sub create `
    --location WestUS `
    --template-file create-resource-group.bicep `
    --parameters '{\"resourceGroupLocation\":{\"value\":\"WestUS\"}}'
