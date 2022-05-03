[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

if($PSCmdlet.ShouldProcess($EnvironmentName)) {
    # Load common configuration values
    . ./earth-config.ps1

    Write-Information ""
    Write-Information "Destroying $EnvironmentName environment..."

    az `
        group delete --name $EarthFrontendResourceGroupName `
        -y
}
