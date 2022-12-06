targetScope='resourceGroup'

@description('The location into which regionally scoped resources should be deployed.')
param location string  = resourceGroup().location

param azureContainerRegistryName string

module registry './container-registry.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    location:                   location
    azureContainerRegistryName: azureContainerRegistryName
  }
}

@description('Output the login server property for later use')
output containerLoginServer string = registry.outputs.loginServer
