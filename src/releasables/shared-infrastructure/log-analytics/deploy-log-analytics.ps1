[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Performs Create or Update operation for the Log Analytics resources.
function Set-LogAnalyticsResources {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory = $true)]
        [String]
        $LogAnalyticsResourceGroupName,

        [Parameter(Mandatory = $true)]
        [String]
        $LogAnalyticsResourceGroupAzureRegion,

        [Parameter(Mandatory = $true)]
        [String]
        $LogAnalyticsNamespaceName
    )

    process {
        if ($PSCmdlet.ShouldProcess($LogAnalyticsResourceGroupName)) {
            $DeploymentParameters = @{
                location                    = @{ value = $LogAnalyticsResourceGroupAzureRegion }
                logAnalyticsNamespaceName   = @{ value = $LogAnalyticsNamespaceName }
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
            Write-Information "Provisioning the Log Analytics infra resources..."
            Write-Information "DeploymentParametersJson:"
            Write-Information "$DeploymentParametersJson"
            Write-Information ""

            $ResponseJson = az `
                deployment group create `
                --mode              Complete `
                --resource-group    $LogAnalyticsResourceGroupName `
                --template-file     ./log-analytics-workspace.bicep `
                --parameters        $DeploymentParametersJson

            if (!$?) {
                Write-Error "Resources deployment failed."
            }

            $Response = $ResponseJson | ConvertFrom-Json

            $LogAnalyticsWorkspaceId = $Response.properties.outputs.logAnalyticsWorkspaceId.value

            Write-Information "Provisioning Log Analytics infra resources completed!"
            Write-Information "logAnalyticsWorkspaceId: $logAnalyticsWorkspaceId"

            return $LogAnalyticsWorkspaceId
        }
    }
}

$LogAnalyticsNamespaceName              = "$EnvironmentName-earth-log-analytics"
$LogAnalyticsResourceGroupName          = "$EnvironmentName-earth-log-analytics"
$LogAnalyticsResourceGroupAzureRegion   = "WestUS"

Write-Information "Creating Azure Logging Analytics Infrastructure $LogAnalyticsNamespaceName in $LogAnalyticsResourceGroupAzureRegion..."

$ResourceGroupCreateResponse = az group create `
    --name      $LogAnalyticsResourceGroupName `
    --location  $LogAnalyticsResourceGroupAzureRegion

if (!$?) {
    Write-Information   $ResourceGroupCreateResponse
    Write-Information   ""
    Write-Error         "Failed to create resource group $LogAnalyticsResourceGroupName!"
}

Write-Information "Resource group created, deploying infrastructure to it..."

Set-LogAnalyticsResources `
    -EnvironmentName                        $EnvironmentName `
    -LogAnalyticsResourceGroupName          $LogAnalyticsResourceGroupName `
    -LogAnalyticsResourceGroupAzureRegion   $LogAnalyticsResourceGroupAzureRegion `
    -LogAnalyticsNamespaceName              $LogAnalyticsNamespaceName
