[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load common configuration values
. ./earth-config.ps1

$Parameters = '{\"earthFrontendResourceGroupName\":{\"value\":\"' + $EarthFrontendResourceGroupName + '\"}, \"resourceGroupLocation\":{\"value\":\"' + $EarthFrontendResourceGroupLocation + '\"}}'

az `
    deployment sub create `
    --location $EarthFrontendResourceGroupLocation `
    --template-file earth-frontend.bicep `
    --parameters $Parameters
