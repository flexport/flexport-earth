param logAnalyticsNamespaceName string
param location                  string = resourceGroup().location

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name:       logAnalyticsNamespaceName
  location:   location
  properties: {
                sku:              {
                                    name: 'PerGB2018'
                                  }
                retentionInDays:  120
                features:         {
                                    searchVersion:                                1
                                    legacy:                                       0
                                    enableLogAccessUsingOnlyResourcePermissions:  true
                                  }
  }
}
