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
    $EarthWebsiteBaseUrl,

    [Parameter(Mandatory = $true)]
    [PSCustomObject]
    $LowerEnvironmentContainerRegistry,

    [Parameter(Mandatory = $true)]
    [PSCustomObject]
    $ContainerRegistry
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Performs Create or Update operation for the E2E Monitor resources.
function Set-E2EMonitorResources {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $ContainerRegistry,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $E2ETestsConfig,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $E2EMonitorConfig,

        [Parameter(Mandatory = $true)]
        [String]
        $EarthWebsiteBaseUrl
    )

    process {
        if ($PSCmdlet.ShouldProcess($E2EMonitorConfig.E2EMonitorResourceGroupName)) {
            Write-Information ""
            Write-Information "Provisioning the E2E Monitor Resources..."
            Write-Information ""

            $ContainerImage = "$($ContainerRegistry.RegistryServerAddress)/$($E2ETestsConfig.E2ETestsContainerImageAndTag)"

            $DeploymentParameters = @{
                location                    = @{ value = $E2EMonitorConfig.E2EMonitorResourceGroupAzureRegion }
                containerRegistryServerName = @{ value = $ContainerRegistry.RegistryServerAddress }
                containerRegistryTenant     = @{ value = $ContainerRegistry.RegistryTenant }
                containerRegistryUsername   = @{ value = $ContainerRegistry.RegistryServicePrincipalUsername }
                containerRegistryPassword   = @{ value = $ContainerRegistry.RegistryServicePrincipalPassword | ConvertFrom-SecureString -AsPlainText }
                e2eTestContainerImageName   = @{ value = $ContainerImage }
                earthWebsiteBaseUrl         = @{ value = $EarthWebsiteBaseUrl }
                containerGroupName          = @{ value = $E2EMonitorConfig.E2EMonitorContainerGroupName }
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
            Write-Information "Provisioning E2E Monitor Container Group and Containers..."
            Write-Information ""
            Write-Information "Container Group Deployment Parameters:"
            Write-Information $DeploymentParametersJson
            Write-Information ""

            az deployment group create `
                --mode              Complete `
                --resource-group    $E2EMonitorConfig.E2EMonitorResourceGroupName `
                --template-file     ./infrastructure/main.bicep `
                --parameters        $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resources deployment failed."
            }

            Write-Information "Provisioning E2E Monitor Resources completed!"
            Write-Information ""
            Write-Information "Checking that the monitor is working..."

            $ContainerReadyForEvaluation = $false
            $ContainerNameToEvaluate     = ""

            for ($i = 0; $i -le 100; $i++) {
                Write-Information "Getting container statuses..."

                $containersJson = az container show `
                    --resource-group    $E2EMonitorConfig.E2EMonitorResourceGroupName `
                    --name              $E2EMonitorConfig.E2EMonitorContainerGroupName

                $containers = $($containersJson | ConvertFrom-Json).containers

                Write-Information "$($containers.Length) containers found, evaluating..."

                # There's possibly multiple containers in the group,
                # just check on the first one that's finished running (i.e. Terminated)
                foreach ($container in $containers) {
                    $image = $container.image

                    if ($image -eq $ContainerImage) {
                        # Check its state...
                        $ContainerState = $container.instanceView.currentState.state

                        Write-Information "$($container.name) state is $ContainerState"

                        if ($ContainerState -eq "Terminated") {
                            $ContainerReadyForEvaluation = $true
                            $ContainerNameToEvaluate     = $container.name
                            break
                        }
                    } else {
                        Write-Error "Container image $image doesn't match expected $ContainerImage"
                    }
                }

                if ($ContainerReadyForEvaluation) {
                    break
                }

                $WaitTimeSeconds = 10

                Write-Information "Sleeping for $WaitTimeSeconds seconds before checking again..."

                Start-Sleep -Seconds $WaitTimeSeconds
            }

            if ($ContainerReadyForEvaluation -eq $false) {
                Write-Error "Failed to test if container is working successfully."
            }

            Write-Information "Getting logs for container..."

            $ContainerLogs = $(az container logs `
                --resource-group    $E2EMonitorConfig.E2EMonitorResourceGroupName `
                --name              $E2EMonitorConfig.E2EMonitorContainerGroupName `
                --container-name    $ContainerNameToEvaluate) | ConvertTo-Json

            if ($ContainerLogs.Contains("Run Finished") -eq $false) {
                Write-Error "Container logs do not indicate the E2E tests were executed."
            }

            Write-Information "E2E tests were executed!"
        }
    }
}

Write-Information "Deploying E2E Monitor..."
Write-Information ""

# Deploy infrastructure
. ../e2e-tests-config.ps1
. ./e2e-monitor-config.ps1

$E2ETestsConfig = Get-E2ETestConfig `
    -EnvironmentName    $EnvironmentName `
    -BuildNumber        $BuildNumber

$E2EMonitorConfig = Get-E2EMonitorConfig `
    -EnvironmentName    $EnvironmentName `
    -BuildNumber        $BuildNumber

# Ensure the image from the lower environment has
# been promoted/imported so that it can be used.

../../../shared-infrastructure/containers/import-image-from-registry.ps1 `
    -FromContainerRegistry  $LowerEnvironmentContainerRegistry `
    -ToContainerRegistry    $ContainerRegistry `
    -ImageName              $E2ETestsConfig.E2ETestsContainerImageName `
    -ImageTag               $BuildNumber

Write-Information "Creating resource group $($E2EMonitorConfig.E2EMonitorResourceGroupName)..."

$ResourceGroupCreateResponse = az group create `
    --name      $E2EMonitorConfig.E2EMonitorResourceGroupName `
    --location  $E2EMonitorConfig.E2EMonitorResourceGroupAzureRegion

if (!$?) {
    Write-Information   $ResourceGroupCreateResponse
    Write-Information   ""
    Write-Error         "Failed to create resource group $($E2EMonitorConfig.E2EMonitorResourceGroupName)!"
}

Write-Information "Resource group created, deploying infrastructure to it..."

Set-E2EMonitorResources `
    -EnvironmentName        $EnvironmentName `
    -ContainerRegistry      $ContainerRegistry `
    -E2ETestsConfig         $E2ETestsConfig `
    -E2EMonitorConfig       $E2EMonitorConfig `
    -EarthWebsiteBaseUrl    $EarthWebsiteBaseUrl

Write-Information ""
Write-Information "E2E Monitor Deployed!"
Write-Information ""