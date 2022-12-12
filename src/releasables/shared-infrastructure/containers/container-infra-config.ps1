Set-StrictMode –Version latest

function Get-ContainerInfraConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $EnvironmentName
    )

    if($PSCmdlet.ShouldProcess($EnvironmentName)) {
        $ContainerRegistryName = "${EnvironmentName}earthregistry"

        $Config = @{
            ContainerInfraResourceGroupName        = "$EnvironmentName-earth-container-infra"
            ContainerInfraResourceGroupAzureRegion = "WestUS"
            ContainerRegistryName                  = $ContainerRegistryName
            ContainerRegistryServerAddress         = "$ContainerRegistryName.azurecr.io"
        }

        $Config
    }
}
