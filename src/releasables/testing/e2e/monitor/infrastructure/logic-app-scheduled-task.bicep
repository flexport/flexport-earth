@description('The Subscription ID where the Logic App will run.')
param subscriptionId string = subscription().id

@description('The name of the logic app to create.')
param logicAppName string = 'e2e-monitor-scheduled-task'

@description('The name of the Resource Group where the Logic App will run.')
param e2eTestMonitorResourceGroupName string = resourceGroup().name

@description('Location for all resources.')
param e2eTestMonitorResourceGroupLocation string = resourceGroup().location

@description('The name of the Container Group to start to run the E2E Tests.')
param e2eTestMonitorContainerGroupName string

param deployerServicePrincipalTenent    string
param deployerServicePrincipalUsername  string

@secure()
param deployerServicePrincipalPassword  string

var frequency       = 'Minute'
var interval        = '30'
var type            = 'recurrence'
var workflowSchema  = 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
var connectionName = 'aci'

@description('Generated from /subscriptions/d91544af-4f4c-422e-82d4-655d4360e7b2/resourceGroups/malex-earth-e2e-monitor/providers/Microsoft.Web/connections/aci')
resource aci 'Microsoft.Web/connections@2016-06-01' = {
  properties: {
    displayName: 'deployer-service-principal'
    parameterValues: {
      'token:clientId':     deployerServicePrincipalUsername
      'token:clientSecret': deployerServicePrincipalPassword
      'token:TenantId':     deployerServicePrincipalTenent
      'token:grantType':    'client_credentials'
    }
    api: {
      name:         connectionName
      id:           subscriptionResourceId('Microsoft.Web/locations/managedApis', e2eTestMonitorResourceGroupLocation, connectionName)
      displayName:  'Azure Container Instance'
      description:  'Easily run containers on Azure with a single command. Create container groups, get the logs of a container and more.'
      iconUri:      'https://connectoricons-prod.azureedge.net/releases/v1.0.1479/1.0.1479.2452/aci/icon.png'
      brandColor:   '#0089D0'
      type:         'Microsoft.Web/locations/managedApis'
    }
  }
  name:     connectionName
  location: e2eTestMonitorResourceGroupLocation
}

resource stg 'Microsoft.Logic/workflows@2019-05-01' = {
  name:     logicAppName
  location: e2eTestMonitorResourceGroupLocation
  tags: {
    displayName: logicAppName
  }
  properties: {
    definition: {
      '$schema':      workflowSchema
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
            defaultValue: {}
            type: 'Object'
        }
      }
      triggers: {
        recurrence: {
          type: type
          recurrence: {
            frequency: frequency
            interval:   interval
          }
        }
      }
      actions: {
        Start_containers_in_a_container_group: {
            inputs: {
                host:     {
                              connection: {
                                name: '@parameters(\'$connections\')[\'aci\'][\'connectionId\']'
                              }
                          }
                method:   'post'
                path:     '${subscriptionId}/resourceGroups/@{encodeURIComponent(\'${e2eTestMonitorResourceGroupName}\')}/providers/Microsoft.ContainerInstance/containerGroups/@{encodeURIComponent(\'${e2eTestMonitorContainerGroupName}\')}/start'
                queries:  {
                              'x-ms-api-version': '2019-12-01'
                          }
            }
            runAfter: {}
            type: 'ApiConnection'
        }
      }
    }
    parameters: {
      '$connections': {
        value: {
          aci: {
            connectionId: '${subscriptionId}/resourceGroups/${e2eTestMonitorResourceGroupName}/providers/Microsoft.Web/connections/aci'
            connectionName: aci.name
            id: '${subscriptionId}/providers/Microsoft.Web/locations/${e2eTestMonitorResourceGroupLocation}/managedApis/aci'
          }
        }
      }
    }
  }
}
