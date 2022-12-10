Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Get-EarthRuntimeConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false)]
        [String]
        $EnvironmentName
    )

    if($PSCmdlet.ShouldProcess($EnvironmentName)) {
        $Config = [PSCustomObject]@{
            EarthDeployerServicePrincipalName  = "$EnvironmentName-earth-deployer"
        }

        return $Config
    }
}
