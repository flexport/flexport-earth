targetScope='resourceGroup'

@description('The location into which website should be deployed.')
param location string = resourceGroup().location

param websiteName string

param appServicePlanName string = '${websiteName}Plan'

param logAnalyticsWorkspaceId string

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

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name:       'earth-website-diagnostics-settings'
  scope:      nextJSwebsite
  properties: {
                logAnalyticsDestinationType:  'AzureDiagnostics'
                logs:                         [
                                                {
                                                  category:         'AppServiceHTTPLogs'
                                                  enabled:          true
                                                  retentionPolicy:  {
                                                                        days:     0
                                                                        enabled:  false
                                                                    }
                                                }
                ]
                workspaceId:                    logAnalyticsWorkspaceId
              }
}

output hostname   string = nextJSwebsite.properties.hostNames[0]
output resourceId string = nextJSwebsite.id
