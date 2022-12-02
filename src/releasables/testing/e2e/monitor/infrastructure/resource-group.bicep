targetScope='subscription'

param resourceGroupName     string
param resourceGroupLocation string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name:     resourceGroupName
  location: resourceGroupLocation
}
