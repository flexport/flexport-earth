[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

. ./e2e-monitor-config.ps1

if($PSCmdlet.ShouldProcess($EnvironmentName)) {
    # Load common configuration values

    $E2EMonitorConfig               = Get-E2EMonitorConfig -EnvironmentName $EnvironmentName
    $E2EMonitorResourceGroupName    = $E2EMonitorConfig.E2EMonitorResourceGroupName

    $Exists = az group exists --resource-group $E2EMonitorResourceGroupName

    if($Exists -eq "true") {
        Write-Information ""
        Write-Information "Destroying E2E Monitor in the $EnvironmentName environment..."

        az group delete `
            --name $E2EMonitorResourceGroupName `
            --yes

        if (!$?) {
            Write-Error "Deletion of resource group $E2EMonitorResourceGroupName failed!"
        }

        Write-Information "E2E Monitor destroyed!"
    } else {
        Write-Information "Resource group $E2EMonitorResourceGroupName doesn't exist, moving on..."
    }
}
