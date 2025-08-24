@description('The location used for all deployed resources')
param location string

@description('Tags that will be applied to all resources')
param tags object = {}

@description('Abbreviations for Azure resource naming')
param abbrs object

@description('Unique token for resource naming')
param resourceToken string

@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@description('Log Analytics workspace Resource ID')
param logAnalyticsWorkspaceResourceId string

// Azure Service Bus for messaging
module servicebus 'br/public:avm/res/service-bus/namespace:0.15.0'= {
 name: 'servicebus'
  params: {
    name: '${abbrs.serviceBusNamespaces}${resourceToken}-${environmentName}'
    location: location
    skuObject: { name: environmentName == 'prd' ? 'Premium' : 'Standard' }
    tags: tags
    diagnosticSettings: [
        {
           workspaceResourceId: logAnalyticsWorkspaceResourceId
        }
    ]
  }
}

// Outputs for use by other modules
@description('Service Bus name')
output serviceBusName string = servicebus.outputs.name

@description('Service Bus resource ID')
output serviceBusResourceId string = servicebus.outputs.resourceId
