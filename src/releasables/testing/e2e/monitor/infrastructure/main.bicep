targetScope='resourceGroup'

@description('The location into which regionally scoped resources should be deployed.')
param location string  = resourceGroup().location

@description('The name of the container group.')
param containerGroupName string

param containerRegistryServerName string

@secure()
param containerRegistryPassword string

@description('Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials.')
param image string

param targetWebsiteUrl string

// Deploying storage account using module
// module storage './storage.bicep' = {
//   name: 'storageDeployment'
//   params: {
//     location:             location
//     environmentShortName: environmentShortName
//   }
// }

module storage './container.bicep' = {
  name: 'e2eMonitorContainer'
  params: {
    location:                     location
    containerGroupName:           containerGroupName
    image:                        image
    containerRegistryServerName:  containerRegistryServerName
    containerRegistryPassword:    containerRegistryPassword
    targetWebsiteUrl:             targetWebsiteUrl
  }
}
