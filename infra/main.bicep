targetScope = 'subscription'

@minLength(1)
@maxLength(5)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

// Application
@description('Application name to be used in components')
param resourceToken string = toLower(uniqueString(subscription().id, environmentName, location))
@description('Application resource group')
param resourceGroupName string = ''

// Optional parameters to override the default azd resource naming conventions. Update the main.parameters.json file to provide values. e.g.,:
// "resourceGroupName": {
//      "value": "myGroupName"
// }
param applicationInsightsDashboardName string = ''
param applicationInsightsName string = ''
param keyVaultName string = ''
param logAnalyticsName string = ''
param serviceBusName string = ''
param logicAppServicePlanName string = ''

@description('Id of the user or app to assign application roles')
param principalId string = ''

var abbrs = loadJsonContent('./abbreviations.json')
var tags = { 'azd-env-name': environmentName }

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${resourceToken}-hub-${environmentName}'
  location: location
  tags: tags
}

// Monitor application with Azure Monitor
module monitoring './core/monitor/monitoring.bicep' = {
  name: 'monitoring'
  scope: rg
  params: {
    location: location
    tags: tags
    logAnalyticsName: !empty(logAnalyticsName) ? logAnalyticsName : '${abbrs.operationalInsightsWorkspaces}${resourceToken}-hub-${environmentName}'
    applicationInsightsName: !empty(applicationInsightsName) ? applicationInsightsName : '${abbrs.insightsComponents}${resourceToken}-hub-${environmentName}'
    applicationInsightsDashboardName: !empty(applicationInsightsDashboardName) ? applicationInsightsDashboardName : '${abbrs.portalDashboards}${resourceToken}-hub-${environmentName}'
  }
}

// Keyvault
module keyVault './avm/key-vault/vault/main.bicep' = {
  name: 'keyvault'
  scope: rg
  params: {
    name: !empty(keyVaultName) ? keyVaultName : '${abbrs.keyVaultVaults}${resourceToken}hub${environmentName}'
    location: location
    sku: 'standard'
    enablePurgeProtection: false
    tags: tags
  }
}

// Service Bus instance
module serviceBus './avm/service-bus/namespace/main.bicep' = {
  name: 'serviceBus'
  scope: rg
  params: {
    tags: tags
    name: !empty(serviceBusName) ? serviceBusName : '${abbrs.serviceBusNamespaces}${resourceToken}-hub-${environmentName}'
    skuObject: { name: 'Standard' }
    location: location
  }
  dependsOn: [
  ]
}

//App Service Plan for hosting Logic Apps Standard
module logicAppServicePlan './avm/web/serverfarm/main.bicep' = {
  name: 'logicappserviceplan'
  scope: rg
  params: {
    tags: tags
    location: location
    name: !empty(logicAppServicePlanName) ? logicAppServicePlanName : '${abbrs.webServerFarms}${abbrs.logicWorkflows}${resourceToken}-hub-${environmentName}'
    skuName: 'WS1'
    kind: 'Elastic'
    skuCapacity: 1
    reserved: false
  }
  dependsOn: [
    keyVault
  ]
}

// App outputs
output APPLICATIONINSIGHTS_CONNECTION_STRING string = monitoring.outputs.applicationInsightsConnectionString
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_RESOURCE_GROUP string = rg.name
