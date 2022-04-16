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

az `
    group delete --name $EarthFrontendResourceGroupName `
    -y
