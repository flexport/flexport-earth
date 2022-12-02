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
    . ./earth-runtime-config.ps1

    Write-Information ""
    Write-Information "Destroying $EnvironmentName environment..."

    try {
        Push-Location "./testing/e2e/monitor"

        ./destroy-e2e-monitor.ps1 `
            -EnvironmentName $EnvironmentName
    }
    finally {
        Pop-Location
    }

    az `
        group delete --name $EarthFrontendResourceGroupName `
        -y
}
