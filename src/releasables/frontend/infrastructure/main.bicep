targetScope='resourceGroup'

@description('The location into which regionally scoped resources should be deployed.')
param location string = resourceGroup().location

param environmentShortName string

@description('The name of the Front Door endpoint to create. This must be globally unique.')
param frontDoorEndpointName string = '${environmentShortName}-earth-cdn-endpoint'

@description('The name of the SKU to use when creating the Front Door profile.')
@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param frontDoorSkuName string = 'Standard_AzureFrontDoor'

param websiteName string = '${environmentShortName}-earth-website'

param customDomainName string

module website 'website.bicep' = {
  name: 'earth-website'
  params: {
    location: location
    websiteName: websiteName
  }
}

module frontDoor 'cdn-front-door.bicep' = {
  name: 'front-door'
  params: {
    skuName: frontDoorSkuName
    endpointName: frontDoorEndpointName
    originHostName: website.outputs.hostname
    dnsZoneName: customDomainName
    cnameRecordName: 'www'
  }
}

output websiteName string = websiteName
output frontDoorEndpointName string = frontDoorEndpointName
output frontDoorEndpointHostName string = frontDoor.outputs.frontDoorEndpointHostName
