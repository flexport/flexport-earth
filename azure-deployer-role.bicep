targetScope = 'subscription'

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
var roleDefName = '964a8f32-c94f-41f7-9a01-f9d31fd51139'

resource roleDef 'Microsoft.Authorization/roleDefinitions@2018-07-01' = {
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
      subscription().id
    ]
  }
}
