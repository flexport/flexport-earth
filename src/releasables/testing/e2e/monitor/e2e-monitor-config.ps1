Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Get-E2EMonitorConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory=$false)]
        [String]
        $BuildNumber
    )

    if($PSCmdlet.ShouldProcess($EnvironmentName)) {
        $E2EMonitorConfig = [PSCustomObject]@{
            E2EMonitorResourceGroupName        = "$EnvironmentName-earth-e2e-monitor"
            E2EMonitorResourceGroupAzureRegion = "WestUS"
        }

        $E2EMonitorConfig
    }
}
