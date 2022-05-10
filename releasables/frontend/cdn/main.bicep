@description('The location into which regionally scoped resources should be deployed. Note that Front Door is a global resource.')
param location string = resourceGroup().location

@description('The name of the Azure Storage account to create. This must be globally unique.')
param storageAccountName string

@description('The name of the SKU to use when creating the Azure Storage account.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Standard_GZRS'
  'Premium_LRS'
])
param storageSkuName string = 'Standard_LRS'

@description('The name of the Front Door endpoint to create. This must be globally unique.')
param frontDoorEndpointName string = 'afd-${uniqueString(resourceGroup().id)}'

@description('The name of the SKU to use when creating the Front Door profile.')
@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param frontDoorSkuName string = 'Standard_AzureFrontDoor'

param customDomainName string

module storage 'modules/storage-static-website.bicep' = {
  name: 'storage'
  params: {
    location: location
    accountName: storageAccountName
    skuName: storageSkuName
  }
}

module frontDoor 'modules/front-door.bicep' = {
  name: 'front-door'
  params: {
    skuName: frontDoorSkuName
    endpointName: frontDoorEndpointName
    originHostName: storage.outputs.staticWebsiteHostName
    dnsZoneName: customDomainName
    cnameRecordName: 'www'
  }
}

output storageAccountName string = storage.outputs.storageAccountName
output frontDoorEndpointHostName string = frontDoor.outputs.frontDoorEndpointHostName
output storageStaticWebsiteHostName string = storage.outputs.staticWebsiteHostName
