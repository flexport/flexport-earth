targetScope='resourceGroup'

@description('The location into which regionally scoped resources should be deployed.')
param location string  = resourceGroup().location

@description('The name of the container group.')
param containerGroupName string

param containerRegistryServerName string

param containerRegistryUsername string

@secure()
param containerRegistryPassword string

@description('Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials.')
param e2eTestContainerImageName string

param earthWebsiteBaseUrl string

// Deploying storage account using module
// module storage './storage.bicep' = {
//   name: 'storageDeployment'
//   params: {
//     location:             location
//     environmentShortName: environmentShortName
//   }
// }

module storage './container-group.bicep' = {
  name: 'E2EMonitorContainerGroup'
  params: {
    location:                     location
    containerGroupName:           containerGroupName
    e2eTestContainerImageName:    e2eTestContainerImageName
    containerRegistryServerName:  containerRegistryServerName
    containerRegistryUsername:    containerRegistryUsername
    containerRegistryPassword:    containerRegistryPassword
    earthWebsiteBaseUrl:          earthWebsiteBaseUrl
  }
}
