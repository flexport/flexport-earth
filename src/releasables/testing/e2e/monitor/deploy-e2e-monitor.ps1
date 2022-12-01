[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName,

    [Parameter(Mandatory = $true)]
    [String]
    $DeployLocation
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Performs Create or Update operation for the E2E Monitor Resource Group.
function Set-E2EMonitorResourceGroup {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory = $true)]
        [String]
        $DeployLocation
    )

    process {
        if ($PSCmdlet.ShouldProcess($DeployLocation)) {
            $DeploymentParameters = [PSCustomObject]@{
                environmentShortName = @{ value = $EnvironmentName.ToLower() }
                resourceGroupLocation= @{ value = $DeployLocation }
            }

            $DeploymentParametersJson = $DeploymentParameters | ConvertTo-Json
            $DeploymentParametersJson = $DeploymentParametersJson.Replace('"', '\"')

            Write-Information ""
            Write-Information "Provisioning the E2E Monitor Resource Group..."
            Write-Information "DeploymentParametersJson:"
            Write-Information "$DeploymentParametersJson"
            Write-Information ""

            $CreateResponseJson = az `
                deployment sub create `
                --location $DeployLocation `
                --template-file ./infrastructure/resource-group.bicep `
                --parameters $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resource group deployment failed!"
                Exit 1
            }

            $CreateResponse     = $CreateResponseJson | ConvertFrom-Json
            $ResourceGroupName  = $CreateResponse.properties.outputs.resourceGroupName.value

            Write-Information "Provisioning E2E Monitor Resource Group $ResourceGroupName completed!"

            # Return the name
            $ResourceGroupName
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
            Write-Information "Environment Name:            $EnvironmentName"
            Write-Information "Deploy Location:             $DeployLocation"
            Write-Information "E2EMonitorResourceGroupName: $E2EMonitorResourceGroupName"
            Write-Information ""

            az `
                deployment group create `
                --mode Complete `
                --resource-group $E2EMonitorResourceGroupName `
                --template-file ./infrastructure/main.bicep `
                --parameters $DeploymentParametersJson

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

# Deploy e2e code
# az storage blob sync `
#     --account-name "malexvmstorage" `
#     --account-key "..." `
#     --container e2e `
#     --source "./e2e" `
#     --exclude-path "cypress.io/node_modules;cypress.io/results"
