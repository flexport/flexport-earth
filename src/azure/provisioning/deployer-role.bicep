targetScope = 'managementGroup'

param azureTenantId string

var actions = [
  '*'
]

var notActions = [
  'Microsoft.Authorization/elevateAccess/Action'
  'Microsoft.Blueprint/blueprintAssignments/write'
  'Microsoft.Blueprint/blueprintAssignments/delete'
  'Microsoft.Compute/galleries/share/action'
]

var roleName = 'Deployer'
var roleDescription = 'Used by Continuous Delivery systems to deploy infrastructure and applications. Grants full access to manage all resources, but does not allow you to manage assignments in Azure Blueprints, or share image galleries.'
var roleDefName = '3f2e82ea-79ee-4cf7-aa80-15313d5c2baf'

resource roleDef 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: roleDefName
  properties: {
    roleName: roleName
    description: roleDescription
    type: 'customRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
      }
    ]
    assignableScopes: [
      '/providers/Microsoft.Management/managementGroups/${azureTenantId}'
    ]
  }
}
