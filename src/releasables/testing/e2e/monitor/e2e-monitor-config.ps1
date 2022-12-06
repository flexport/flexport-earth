Set-StrictMode –Version latest

function Get-E2EMonitorConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory=$true)]
        [String]
        $BuildNumber
    )

    if($PSCmdlet.ShouldProcess($EnvironmentName)) {
        $E2EMonitorConfig = [PSCustomObject]@{
            E2EMonitorResourceGroupName        = "$EnvironmentName-e2e-monitor"
            E2EMonitorResourceGroupAzureRegion = "WestUS2"
            E2EMonitorContainerImageName       = "earth-e2e-tests:$BuildNumber"
        }

        $E2EMonitorConfig
    }
}
