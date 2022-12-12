@description('Name for the container group')
param containerGroupName string

@description('Location for all resources.')
param location string = resourceGroup().location

param containerRegistryServerName string

param containerRegistryUsername string = '00000000-0000-0000-0000-000000000000'

@secure()
param containerRegistryPassword string

@description('Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials.')
param e2eTestContainerImageName string

param earthWebsiteBaseUrl string

@description('The number of CPU cores to allocate to the container.')
param cpuCores int = 2

@description('The amount of memory to allocate to the container in gigabytes.')
param memoryInGb int = 4

@description('The behavior of Azure runtime if container has stopped.')
@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Never'

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: containerGroupName
  location: location
  properties: {
    containers: [
      {
        name: containerGroupName
        properties: {
          image: e2eTestContainerImageName
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
          environmentVariables: [
            {
              name: 'CYPRESS_EARTH_WEBSITE_URL'
              value: earthWebsiteBaseUrl
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
    imageRegistryCredentials: [
      {
        server:   containerRegistryServerName
        username: containerRegistryUsername
        password: containerRegistryPassword
      }
    ]
  }
}
