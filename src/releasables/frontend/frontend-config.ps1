Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Get-FrontendConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $EnvironmentName
    )

    if($PSCmdlet.ShouldProcess($EnvironmentName)) {
        $Config = [PSCustomObject]@{
            EarthFrontendResourceGroupName     = "$EnvironmentName-earth-frontend".ToLower()
            EarthFrontendResourceGroupLocation = "WestUS"
        }

        $Config
    }
}
