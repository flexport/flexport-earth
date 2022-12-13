targetScope='resourceGroup'

@description('The location into which regionally scoped resources should be deployed.')
param location string  = resourceGroup().location

@description('The name of the container group.')
param containerGroupName string

@description('The Container Registry to use for pulling the E2E Test Conainter images.')
param containerRegistryServerName string

@description('The Container Registry to use for pulling the E2E Test Conainter images.')
param containerRegistryTenant string

@description('The username that the Container Instance service should use to authenticate with the Container Registry when pulling the E2E Test Conainter images.')
param containerRegistryUsername string

@description('The password that the Container Instance service should use to authenticate with the Container Registry when pulling the E2E Test Conainter images.')
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

module containerGroup './container-group.bicep' = {
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

module logicAppScheduledTask './logic-app-scheduled-task.bicep' = {
  name: 'E2EMonitorLogicApp'
  params: {
    e2eTestMonitorContainerGroupName:     containerGroupName
    e2eTestMonitorResourceGroupLocation:  location
    deployerServicePrincipalTenent:       containerRegistryTenant
    deployerServicePrincipalUsername:     containerRegistryUsername
    deployerServicePrincipalPassword:     containerRegistryPassword
  }
}
