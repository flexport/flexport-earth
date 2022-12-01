targetScope='subscription'

param environmentShortName  string
param resourceGroupLocation string
param resourceGroupName     string = '${environmentShortName}-e2e-monitor'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name:     resourceGroupName
  location: resourceGroupLocation
}

output resourceGroupName string = resourceGroup.name
