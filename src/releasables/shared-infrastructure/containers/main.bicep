targetScope='resourceGroup'

@description('The location into which regionally scoped resources should be deployed.')
param location string  = resourceGroup().location

@description('The short name or prefix of the target environment.')
param environmentShortName string

module registry './container-registry.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    location:             location
    environmentShortName: environmentShortName
  }
}

@description('Output the login server property for later use')
output containerLoginServer string = registry.outputs.loginServer
