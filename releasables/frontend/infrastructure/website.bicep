targetScope='resourceGroup'

@description('The location into which website should be deployed.')
param location string = resourceGroup().location

param websiteName string

param appServicePlanName string = '${websiteName}Plan'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'B1'
  }
  kind: 'linux'
}

resource nextJSwebsite 'Microsoft.Web/sites@2021-03-01' = {
  name: websiteName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|16-lts'
    }
  }
}

output hostname string = nextJSwebsite.properties.hostNames[0]
