targetScope='resourceGroup'

@description('The location into which regionally scoped resources should be deployed.')
param location string  = resourceGroup().location

@description('The short name or prefix of the target environment.')
param environmentShortName string

// Deploying storage account using module
module storage './storage.bicep' = {
  name: 'storageDeployment'
  params: {
    location:             location
    environmentShortName: environmentShortName
  }
}
