[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

# Load common configuration values
. ./earth-config.ps1

az `
    group delete --name $EarthFrontendResourceGroupName `
    -y
