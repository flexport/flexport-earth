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
    Write-Information ""

    try {
        Push-Location "./testing/e2e/monitor"

        ./destroy-e2e-monitor.ps1 `
            -EnvironmentName $EnvironmentName
    }
    finally {
        Pop-Location
    }

    $Exists = az group exists --resource-group $EarthFrontendResourceGroupName

    if($Exists -eq "true") {
        az group delete `
            --name $EarthFrontendResourceGroupName `
            -yes
    } else {
        Write-Information "Resource group $EarthFrontendResourceGroupName doesn't exist, moving on..."
    }

    if (!$?) {
        Write-Information ""
        Write-Error "Deletion of the frontend resource group $EarthFrontendResourceGroupName failed!"
    }

    try {
        Push-Location "./shared-infrastructure/containers"

        ./destroy-container-infrastructure.ps1 `
            -EnvironmentName $EnvironmentName
    }
    finally {
        Pop-Location
    }
}

Write-Information ""
Write-Information "All Earth resources have been deleted."