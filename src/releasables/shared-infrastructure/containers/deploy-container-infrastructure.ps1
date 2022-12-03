[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Performs Create or Update operation for the Container Infra Resource Group.
function Set-ContainerInfraResourceGroup {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $ContainerInfraResourceGroupName,

        [Parameter(Mandatory = $true)]
        [String]
        $ContainerInfraResourceGroupAzureRegion
    )

    process {
        if ($PSCmdlet.ShouldProcess($ContainerInfraResourceGroupName)) {
            $DeploymentParameters = [PSCustomObject]@{
                resourceGroupName    = @{ value = $ContainerInfraResourceGroupName }
                resourceGroupLocation= @{ value = $ContainerInfraResourceGroupAzureRegion }
            }

            $DeploymentParametersJson = $DeploymentParameters | ConvertTo-Json

            Write-Information ""
            Write-Information "Provisioning the Container infra Resource Group..."
            Write-Information "DeploymentParametersJson:"
            Write-Information "$DeploymentParametersJson"
            Write-Information ""

            az deployment sub create `
                --location      $ContainerInfraResourceGroupAzureRegion `
                --template-file ./resource-group.bicep `
                --parameters    $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resource group deployment failed!"
            }

            Write-Information "Provisioning Container Resource Group $ContainerInfraResourceGroupName completed!"
        }
    }
}

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
        $ContainerInfraResourceGroupAzureRegion
    )

    process {
        if ($PSCmdlet.ShouldProcess($ContainerInfraResourceGroupName)) {
            $DeploymentParameters = [PSCustomObject]@{
                environmentShortName = @{ value = $EnvironmentName.ToLower() }
                location             = @{ value = $ContainerInfraResourceGroupAzureRegion }
            }

            $DeploymentParametersJson = $DeploymentParameters | ConvertTo-Json

            Write-Information ""
            Write-Information "Provisioning the Container infra resources..."
            Write-Information "DeploymentParametersJson:"
            Write-Information "$DeploymentParametersJson"
            Write-Information ""

            az `
                deployment group create `
                --mode              Complete `
                --resource-group    $ContainerInfraResourceGroupName `
                --template-file     ./main.bicep `
                --parameters        $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resources deployment failed."
                Exit 1
            }

            Write-Information "Provisioning Container infra resources completed!"
        }
    }
}

# Deploy infrastructure
. ./container-infra-config.ps1

$ContainerInfraConfig                   = Get-ContainerInfraConfig -EnvironmentName $EnvironmentName
$ContainerInfraResourceGroupName        = $ContainerInfraConfig.ContainerInfraResourceGroupName
$ContainerInfraResourceGroupAzureRegion = $ContainerInfraConfig.ContainerInfraResourceGroupAzureRegion

Set-ContainerInfraResourceGroup `
    -ContainerInfraResourceGroupName        $ContainerInfraResourceGroupName `
    -ContainerInfraResourceGroupAzureRegion $ContainerInfraResourceGroupAzureRegion

Set-ContainerInfraResources `
    -EnvironmentName                        $EnvironmentName `
    -ContainerInfraResourceGroupName        $ContainerInfraResourceGroupName `
    -ContainerInfraResourceGroupAzureRegion $ContainerInfraResourceGroupAzureRegion
