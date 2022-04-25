[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $AzureSubscriptionName
)

# Enable 'Write-Information' calls to show in the console.
$InformationPreference = 'Continue' 

$SubscriptionId = (az account show --subscription $AzureSubscriptionName | ConvertFrom-Json).id

Write-Information "Deprovisioning subscription $AzureSubscriptionName (id: $SubscriptionId) ..."

function Remove-DeployerServicePrincipal {
    $SubscriptionDeploymentServicePricipalName = "earth-deployer"
    
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

# Remove the deployer service principal if it exists.
Remove-DeployerServicePrincipal
