targetScope='subscription'

param environmentName string
param resourceGroupLocation string

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${environmentName}-earth-front-end'
  location: resourceGroupLocation
}
