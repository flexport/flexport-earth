[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName,

    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory = $true)]
    [String]
    $TargetWebsiteUrl,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerSourceRegistryServerAddress,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerSourceRegistryServicePrincipalUsername,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerSourceRegistryServicePrincipalPwd,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerTargetRegistryName
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
        $E2EMonitorResourceGroupName,

        [Parameter(Mandatory = $true)]
        [String]
        $E2EMonitorResourceGroupAzureRegion
    )

    process {
        if ($PSCmdlet.ShouldProcess($E2EMonitorResourceGroupName)) {
            $DeploymentParameters = [PSCustomObject]@{
                resourceGroupName    = @{ value = $E2EMonitorResourceGroupName }
                resourceGroupLocation= @{ value = $E2EMonitorResourceGroupAzureRegion }
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

            Write-Information "Provisioning E2E Monitor Resource Group $E2EMonitorResourceGroupName completed!"
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
        $E2EMonitorResourceGroupName,

        [Parameter(Mandatory = $true)]
        [String]
        $E2EMonitorResourceGroupAzureRegion,

        [Parameter(Mandatory = $true)]
        [String]
        $ContainerRegistryName,

        [Parameter(Mandatory = $true)]
        [String]
        $E2ETestsContainerImageName,

        [Parameter(Mandatory = $true)]
        [String]
        $TargetWebsiteUrl
    )

    process {
        if ($PSCmdlet.ShouldProcess($E2EMonitorResourceGroupName)) {
            Write-Information ""
            Write-Information "Provisioning the E2E Monitor Resources..."
            Write-Information ""
            Write-Information "Getting Container Registry access token..."
            $Token =    $(az acr login `
                                        --name $ContainerRegistryName `
                                        --expose-token `
                                        --output tsv `
                                        --query accessToken
                        )

            if (!$?) {
                Write-Error "Failed to get access token for the Container Registry!"
            }

            Write-Information "Token acquired!"
            Write-Information ""

            $ContainerImage     = "$ContainerRegistryName.azurecr.io/$E2ETestsContainerImageName"
            $ContainerGroupName = "${EnvironmentName}e2etestmonitorcontainergroup"

            $DeploymentParameters = [PSCustomObject]@{
                location                    = @{ value = $E2EMonitorResourceGroupAzureRegion }
                containerRegistryServerName = @{ value = "$ContainerRegistryName.azurecr.io" }
                containerRegistryPassword   = @{ value = $Token }
                image                       = @{ value = $ContainerImage }
                targetWebsiteUrl            = @{ value = $TargetWebsiteUrl }
                containerGroupName          = @{ value = $ContainerGroupName }
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
            Write-Information "Provisioning Container Group and Containers..."

            az deployment group create `
                --mode              Complete `
                --resource-group    $E2EMonitorResourceGroupName `
                --template-file     ./infrastructure/main.bicep `
                --parameters        $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resources deployment failed."
            }

            Write-Information "Provisioning E2E Monitor Resources completed!"

            Write-Information "Checking that the monitor is working..."

            $ContainerReadyForEvaluation = $false

            for ($i = 0; $i -le 50; $i++) {
                Write-Information "Getting container statuses..."

                $containersJson = az container show `
                    --resource-group    $E2EMonitorResourceGroupName `
                    --name              $ContainerGroupName

                $containers = $containersJson | ConvertFrom-Json

                # Get the container, somehow this array is being
                # auto-translated to the first container in the array...?!
                $container  = $containers.containers
                $image      = $container.image

                if ($image -eq $ContainerImage) {
                    # Check its state...
                    $ContainerState = $container.instanceView.currentState.state

                    Write-Information "$image state is $ContainerState"

                    if ($ContainerState -eq "Terminated") {
                        $ContainerReadyForEvaluation = $true
                        break
                    }
                } else {
                    Write-Error "Container image $image doesn't match expected $ContainerImage"
                }

                Write-Information "Sleeping for 5 seconds before checking again..."

                Start-Sleep -Seconds 5
            }

            if ($ContainerReadyForEvaluation -eq $false) {
                Write-Error "Failed to test if container is working successfully."
            }

            Write-Information "Getting logs for container..."

            $ContainerLogs = $(az container logs `
                --resource-group    $E2EMonitorResourceGroupName `
                --name              $ContainerGroupName) | ConvertTo-Json

            if ($ContainerLogs.Contains("Run Finished") -eq $false) {
                Write-Error "Container logs do not indicate the E2E tests were executed."
            }

            Write-Information "E2E tests were executed!"
        }
    }
}

# Deploy infrastructure
. ../e2e-tests-config.ps1
. ./e2e-monitor-config.ps1

$E2ETestsConfig = Get-E2ETestConfig `
    -EnvironmentName    $EnvironmentName `
    -BuildNumber        $BuildNumber

$E2EMonitorConfig = Get-E2EMonitorConfig `
    -EnvironmentName    $EnvironmentName `
    -BuildNumber        $BuildNumber

$E2ETestsContainerRepository        = $E2ETestsConfig.E2ETestsContainerRepository
$E2ETestsContainerImageName         = $E2ETestsConfig.E2ETestsContainerImageName
$E2ETestsContainerImageAndTag       = $E2ETestsConfig.E2ETestsContainerImageAndTag
$E2EMonitorResourceGroupName        = $E2EMonitorConfig.E2EMonitorResourceGroupName
$E2EMonitorResourceGroupAzureRegion = $E2EMonitorConfig.E2EMonitorResourceGroupAzureRegion

# Ensure the image from the lower environment has
# been promoted/imported so that it can be used.

../../../shared-infrastructure/containers/import-image-from-registry.ps1 `
    -SourceRegistryServerAddress            $ContainerSourceRegistryServerAddress `
    -SourceRegistryServicePrincipalUsername $ContainerSourceRegistryServicePrincipalUsername `
    -SourceRegistryServicePrincipalPwd      $ContainerSourceRegistryServicePrincipalPwd `
    -SourceRegistryImageName                $E2ETestsContainerImageName `
    -SourceRegistryImageReleaseTag          $BuildNumber `
    -DestinationRegistryName                $ContainerTargetRegistryName `
    -DestinationRepositoryName              $E2ETestsContainerRepository

Set-E2EMonitorResourceGroup `
    -E2EMonitorResourceGroupName        $E2EMonitorResourceGroupName `
    -E2EMonitorResourceGroupAzureRegion $E2EMonitorResourceGroupAzureRegion

Set-E2EMonitorResources `
    -EnvironmentName                    $EnvironmentName `
    -E2EMonitorResourceGroupName        $E2EMonitorResourceGroupName `
    -E2EMonitorResourceGroupAzureRegion $E2EMonitorResourceGroupAzureRegion `
    -ContainerRegistryName              $ContainerTargetRegistryName `
    -E2ETestsContainerImageName         $E2ETestsContainerImageAndTag `
    -TargetWebsiteUrl                   $TargetWebsiteUrl
