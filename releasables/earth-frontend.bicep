targetScope='subscription'

param earthFrontendResourceGroupName string
param resourceGroupLocation string

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: earthFrontendResourceGroupName
  location: resourceGroupLocation
}
