Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Get-EarthRuntimeConfig {
    [OutputType('System.Collections.Hashtable')]
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false)]
        [String]
        $AzureSubscriptionName
    )

    if($PSCmdlet.ShouldProcess($AzureSubscriptionName)) {
        $Config = @{
            EarthDeployerServicePrincipalName  = "$AzureSubscriptionName-earth-deployer".ToLower()
        }

        return $Config
    }
}
