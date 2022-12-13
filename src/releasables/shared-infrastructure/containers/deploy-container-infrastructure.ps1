[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Performs Create or Update operation for the Container Infra resources.
function Set-ContainerInfraResources {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory = $true)]
        [String]
        $ContainerInfraResourceGroupName,

        [Parameter(Mandatory = $true)]
        [String]
        $ContainerInfraResourceGroupAzureRegion,

        [Parameter(Mandatory = $true)]
        [String]
        $AzureContainerRegistryName
    )

    process {
        if ($PSCmdlet.ShouldProcess($ContainerInfraResourceGroupName)) {
            $DeploymentParameters = @{
                location                    = @{ value = $ContainerInfraResourceGroupAzureRegion }
                azureContainerRegistryName  = @{ value = $AzureContainerRegistryName }
            }

            $DeploymentParametersJson = $DeploymentParameters | ConvertTo-Json

            # PowerShell v7.3.0 has a breaking change in how it handles
            # parsing double quotes in strings. Previous versions required
            # escaping the double quotes. Dev machines have been updated,
            # but the Azure DevOps machines haven't yet.

            $CurrentPowerShellVersion = $($PSVersionTable.PSVersion)
            $CurrentPowerShellMajorVersion = $CurrentPowerShellVersion.Major
            $CurrentPowerShellMinorVersion = $CurrentPowerShellVersion.Minor

            if ($CurrentPowerShellMajorVersion -le 7 -and $CurrentPowerShellMinorVersion -lt 3) {
                $DeploymentParametersJson = $DeploymentParametersJson.Replace('"', '\"')
            }

            Write-Information ""
            Write-Information "Provisioning the Container infra resources..."
            Write-Information "DeploymentParametersJson:"
            Write-Information "$DeploymentParametersJson"
            Write-Information ""

            $ResponseJson = az `
                deployment group create `
                --mode              Complete `
                --resource-group    $ContainerInfraResourceGroupName `
                --template-file     ./main.bicep `
                --parameters        $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resources deployment failed."
            }

            $Response = $ResponseJson | ConvertFrom-Json

            $ContainerLoginServer = $Response.properties.outputs.containerLoginServer.value

            Write-Information "Provisioning Container infra resources completed!"

            $ContainerLoginServer
        }
    }
}

# Deploy infrastructure
. ./container-infra-config.ps1

$ContainerInfraConfig                   = Get-ContainerInfraConfig -EnvironmentName $EnvironmentName
$ContainerInfraResourceGroupName        = $ContainerInfraConfig.ContainerInfraResourceGroupName
$ContainerInfraResourceGroupAzureRegion = $ContainerInfraConfig.ContainerInfraResourceGroupAzureRegion
$ContainerRegistryName                  = $ContainerInfraConfig.ContainerRegistryName

Write-Information "Creating resource group $ContainerInfraResourceGroupName..."

$ResourceGroupCreateResponse = az group create `
    --name      $ContainerInfraResourceGroupName `
    --location  $ContainerInfraResourceGroupAzureRegion

if (!$?) {
    Write-Information   $ResourceGroupCreateResponse
    Write-Information   ""
    Write-Error         "Failed to create resource group $($FrontendConfig.EarthFrontendResourceGroupName)!"
}

Write-Information "Resource group created, deploying infrastructure to it..."

Set-ContainerInfraResources `
    -EnvironmentName                        $EnvironmentName `
    -ContainerInfraResourceGroupName        $ContainerInfraResourceGroupName `
    -ContainerInfraResourceGroupAzureRegion $ContainerInfraResourceGroupAzureRegion `
    -AzureContainerRegistryName             $ContainerRegistryName
