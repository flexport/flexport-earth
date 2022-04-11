targetScope='subscription'

param resourceGroupLocation string

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'earth-front-end'
  location: resourceGroupLocation
}
