# This file tested with azure-cli 2.33.1

$InformationPreference = 'Continue' # Enable 'Write-Information' calls to show in the console.

$SubscriptionDeploymentServicePricipalName = "earth-deployer"

Write-Information "Removing all resources from up your subscription..."

$SubscriptionDeploymentServicePricipalId = (az ad sp list --display-name $SubscriptionDeploymentServicePricipalName | ConvertFrom-Json)[0].objectId

Write-Information "- Deleting Subscription Deployment Service Pricipal $SubscriptionDeploymentServicePricipalName ($SubscriptionDeploymentServicePricipalId)"
az ad sp delete --id $SubscriptionDeploymentServicePricipalId
