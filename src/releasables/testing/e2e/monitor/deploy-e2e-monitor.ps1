[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

. ./e2e-monitor-config.ps1

# Performs Create or Update operation for the E2E Monitor Resource Group.
function Set-E2EMonitorResourceGroup {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $EnvironmentName
    )

    process {
        if ($PSCmdlet.ShouldProcess($DeployLocation)) {
            $E2EMonitorConfig                   = Get-E2EMonitorConfig -EnvironmentName $EnvironmentName
            $E2EMonitorResourceGroupAzureRegion = $E2EMonitorConfig.E2EMonitorResourceGroupAzureRegion
            $E2EMonitorResourceGroupName        = $E2EMonitorConfig.E2EMonitorResourceGroupName

            $DeploymentParameters = [PSCustomObject]@{
                resourceGroupName    = @{ value = $E2EMonitorResourceGroupName }
                resourceGroupLocation= @{ value = $E2EMonitorResourceGroupAzureRegion }
            }

            $DeploymentParametersJson = $DeploymentParameters | ConvertTo-Json
            $DeploymentParametersJson = $DeploymentParametersJson.Replace('"', '\"')

            Write-Information ""
            Write-Information "Provisioning the E2E Monitor Resource Group..."
            Write-Information "DeploymentParametersJson:"
            Write-Information "$DeploymentParametersJson"
            Write-Information ""

            az deployment sub create `
                --location      $E2EMonitorResourceGroupAzureRegion `
                --template-file ./infrastructure/resource-group.bicep `
                --parameters    $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resource group deployment failed!"
            }

            Write-Information "Provisioning E2E Monitor Resource Group $ResourceGroupName completed!"

            # Return the name
            $E2EMonitorResourceGroupName
        }
    }
}

# Performs Create or Update operation for the E2E Monitor resources.
function Set-E2EMonitorResources {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory = $true)]
        [String]
        $DeployLocation,

        [Parameter(Mandatory = $true)]
        [String]
        $E2EMonitorResourceGroupName
    )

    process {
        if ($PSCmdlet.ShouldProcess($DeployLocation)) {
            $DeploymentParameters = [PSCustomObject]@{
                environmentShortName = @{ value = $EnvironmentName.ToLower() }
                location             = @{ value = $DeployLocation }
            }

            $DeploymentParametersJson = $DeploymentParameters | ConvertTo-Json
            $DeploymentParametersJson = $DeploymentParametersJson.Replace('"', '\"')

            Write-Information ""
            Write-Information "Provisioning the E2E Monitor Resources..."
            Write-Information "DeploymentParametersJson:"
            Write-Information "$DeploymentParametersJson"
            Write-Information ""

            az `
                deployment group create `
                --mode              Complete `
                --resource-group    $E2EMonitorResourceGroupName `
                --template-file     ./infrastructure/main.bicep `
                --parameters        $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resource group deployment failed."
                Exit 1
            }

            Write-Information "Provisioning E2E Monitor Resources completed!"
        }
    }
}

# Deploy infrastructure
$E2EMonitorResourceGroupName = Set-E2EMonitorResourceGroup `
    -EnvironmentName $EnvironmentName `
    -DeployLocation  $DeployLocation

Set-E2EMonitorResources `
    -EnvironmentName                $EnvironmentName `
    -DeployLocation                 $DeployLocation `
    -E2EMonitorResourceGroupName    $E2EMonitorResourceGroupName
