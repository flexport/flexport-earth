Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Get-E2ETestConfig {
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
        $E2ETestsContainerImageName = "earth-e2e-tests"

        $E2EMonitorConfig = [PSCustomObject]@{
            E2ETestsContainerRepository        = $E2ETestsContainerImageName
            E2ETestsContainerImageName         = $E2ETestsContainerImageName
            E2ETestsContainerImageAndTag       = "$E2ETestsContainerImageName\:$BuildNumber"
        }

        $E2EMonitorConfig
    }
}
