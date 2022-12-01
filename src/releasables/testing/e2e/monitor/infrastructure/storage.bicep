targetScope='resourceGroup'

@description('The location into which regionally scoped resources should be deployed.')
param location string = resourceGroup().location

param environmentShortName string

@description('The name of the storage account to create. This must be globally unique.')
param storageAccountName string = '${environmentShortName}earthe2estorage'

resource e2eStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource storageAccountContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${e2eStorageAccount.name}/default/e2e'
  properties: {}
}
