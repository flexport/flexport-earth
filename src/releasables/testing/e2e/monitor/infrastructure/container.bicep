@description('The short name or prefix of the target environment.')
param environmentShortName string

@description('Name for the container group')
param name string = '${environmentShortName}e2etestmonitorcontainergroup'

@description('Location for all resources.')
param location string = resourceGroup().location

param containerRegistryServerName string

param containerRegistryUsername string = '00000000-0000-0000-0000-000000000000'

@secure()
param containerRegistryPassword string

@description('Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials.')
param image string

param targetWebsiteUrl string

@description('The number of CPU cores to allocate to the container.')
param cpuCores int = 1

@description('The amount of memory to allocate to the container in gigabytes.')
param memoryInGb int = 2

@description('The behavior of Azure runtime if container has stopped.')
@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Never'

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: name
  location: location
  properties: {
    containers: [
      {
        name: name
        properties: {
          image: image
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
          environmentVariables: [
            {
              name: 'CYPRESS_EARTH_WEBSITE_URL'
              value: targetWebsiteUrl
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
