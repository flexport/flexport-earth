targetScope='resourceGroup'

param buildNumber string

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

param logAnalyticsWorkspaceId string

param earthEnvironmentOperatorsEmailAddress string

module actionGroup 'action-group.bicep' = {
  name:   '${environmentShortName}-${resourceGroup().name}-action-group'
  params: {
            actionGroupName:      '${resourceGroup().name}-action-group'
            actionGroupShortName: 'envops'
            emailReceivers:       [
                                    {
                                      name:         'Earth Environment Operators'
                                      emailAddress: earthEnvironmentOperatorsEmailAddress
                                    }
                                  ]
          }
}

module website 'website.bicep' = {
  name:   'earth-website'
  params: {
    location:                 location
    websiteName:              websiteName
    logAnalyticsWorkspaceId:  logAnalyticsWorkspaceId
  }
}

module websiteHttp404Alert 'website-404-alert.bicep' = {
  name:   'earth-website-http-404-alert'
  params: {
            alertRuleName:         '${environmentShortName} - Earth Website HTTP 404 Alert (${buildNumber})'
            actionGroupResourceId: actionGroup.outputs.actionGroupId
            webAppResourceId:      website.outputs.resourceId
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

output websiteName                string = websiteName
output frontDoorEndpointName      string = frontDoorEndpointName
output frontDoorEndpointHostName  string = frontDoor.outputs.frontDoorEndpointHostName
