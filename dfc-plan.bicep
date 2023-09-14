@allowed([ 'Standard', 'Free' ])
param pricingName string
param pricingTier string = 'Standard'
param OnUploadMalwareScanning = false

targetScope = 'subscription'

var subPlan = {
    StorageAccounts: 'DefenderForStorageV2'
}

// https://learn.microsoft.com/en-us/rest/api/defenderforcloud/pricings/list?tabs=HTTP
var extensions = {
    StorageAccounts: [
        {
            name: 'OnUploadMalwareScanning'
            isEnabled: OnUploadMalwareScanning ? 'True' : 'False'
            additionalExtensionProperties: OnUploadMalwareScanning ? {
                CapGBPerMonthPerStorageAccount: '5000'
            } : null
        }
        {
            name: 'SensitiveDataDiscovery'
            isEnabled: 'True'
        }
    ]
}

var planpropertis = {
    Free: {
        pricingTier: 'Free'
    }
    Standard: {
        pricingTier: 'Standard'
        subPlan: contains(subPlan, pricingName) ? subPlan[pricingName] : null
        extensions: contains(extensions, pricingName) ? extensions[pricingName] : null
    }
}

#disable-next-line BCP081
resource PRICING 'Microsoft.Security/pricings@2023-01-01' = {
    name: pricingName
    properties: planpropertis[pricingTier]
}