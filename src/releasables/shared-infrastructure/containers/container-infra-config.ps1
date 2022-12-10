Set-StrictMode –Version latest

function Get-ContainerInfraConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $EnvironmentName
    )

    if($PSCmdlet.ShouldProcess($EnvironmentName)) {
        $Config = [PSCustomObject]@{
            ContainerInfraResourceGroupName        = "$EnvironmentName-earth-container-infra"
            ContainerInfraResourceGroupAzureRegion = "WestUS"
            ContainerRegistryName                  = "${EnvironmentName}earthregistry"
        }

        $Config
    }
}
