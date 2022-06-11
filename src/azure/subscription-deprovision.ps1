[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $AzureSubscriptionName
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

$SubscriptionId = (az account show --subscription $AzureSubscriptionName | ConvertFrom-Json).id

Write-Information "Deprovisioning subscription $AzureSubscriptionName (id: $SubscriptionId) ..."

function Remove-DeployerServicePrincipal {
    [CmdletBinding(SupportsShouldProcess)]
    Param()

    process {
        if($PSCmdlet.ShouldProcess($AzureSubscriptionName)) {
            $SubscriptionDeploymentServicePricipalName = "$AzureSubscriptionName-earth-deployer".ToLower()

            $ServicePrincipalId = (
                az ad sp list `
                    --filter "displayname eq '$SubscriptionDeploymentServicePricipalName'" | ConvertFrom-Json
            ).appId

            if ($ServicePrincipalId) {
                Write-Information "Deprovisioning $SubscriptionDeploymentServicePricipalName Service Principal (id: $ServicePrincipalId) ..."

                az ad sp delete --id $ServicePrincipalId

                Write-Information "Service Principal $SubscriptionDeploymentServicePricipalName (id: $ServicePrincipalId) deleted."
            }
        }
    }
}

# Remove the deployer service principal if it exists.
Remove-DeployerServicePrincipal
