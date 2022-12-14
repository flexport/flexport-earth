# Overview

Earth uses Azure [Service Principals](https://learn.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps?view=azps-9.2.0) for accessing Azure resources.

If you've previously provisioned a Service Principal on your machine, you'll find the credentials cached in your `flexport-earth/.cache/azure/creds` folder.

# How to sign into an Earth Azure Subscription via CLI

```
~/git/flexport-earth> ./dev/tools/sign-into-azure.ps1 -AzureSubscriptionName "Development"

Signing into Development Azure Subscription as the Deployer Service Principal development-earth-deployer...
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "ea11df53-83c1-4ffe-b653-cc0d19b61948",
    "id": "eea61605-026c-4cb1-abde-0c6edb2976ff",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Development",
    "state": "Enabled",
    "tenantId": "ea11df53-83c1-4ffe-b653-cc0d19b61948",
    "user": {
      "name": "ad73840d-2248-49b5-9c8f-964667d3c83f",
      "type": "servicePrincipal"
    }
  }
]
You are now signed in as development-earth-deployer
```