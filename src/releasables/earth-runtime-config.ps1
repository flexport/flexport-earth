Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Get-EarthRuntimeConfig {
    [OutputType('System.Collections.Hashtable')]
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false)]
        [String]
        $EnvironmentName
    )

    if($PSCmdlet.ShouldProcess($EnvironmentName)) {
        $Config = @{
            EarthDeployerServicePrincipalName  = "$EnvironmentName-earth-deployer"
        }

        return $Config
    }
}
