@description('The location into which the Azure Storage resources should be deployed.')
param location string

@description('The name of the Azure Storage account to create. This must be globally unique.')
param accountName string

@description('The name of the SKU to use when creating the Azure Storage account.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Standard_GZRS'
  'Premium_LRS'
])
param skuName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: accountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
}

output storageAccountName string = storageAccount.name
output staticWebsiteHostName string = replace(replace(storageAccount.properties.primaryEndpoints.web, 'https://', ''), '/', '')
output storageResourceId string = storageAccount.id
output storageLocation string = storageAccount.location
