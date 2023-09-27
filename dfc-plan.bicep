param SecurityPricingInfo array

targetScope = 'subscription'

var securityPricing = [for (sp, index) in SecurityPricingInfo: {
    name: sp.pricingName
    properties: {
        pricingTier: sp.pricingTier
        subPlan: contains(sp.subPlan, sp.pricingName) ? sp.subPlan[sp.pricingName] : null
        extensions: contains(sp.extensions, sp.pricingName) ? sp.extensions[sp.pricingName] : null
    }
}]

@batchSize(1)
resource PRICING 'Microsoft.Security/pricings@2023-01-01' = [for (pricing, index) in securityPricing: {
    name: pricing.name
    properties: pricing.properties
}]
