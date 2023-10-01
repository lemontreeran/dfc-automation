param SecurityPricingInfo array

targetScope = 'subscription'

var subscriptionId = ${subscription().subscriptionId}
var securityPricing = [for (sp, index) in SecurityPricingInfo: {
    name: sp.pricingName
    properties: {
        pricingTier: sp.pricingTier
        subPlan: contains(sp.subPlan, sp.pricingName) ? sp.subPlan[sp.pricingName] : null
        extensions: contains(sp.extensions, sp.pricingName) ? sp.extensions[sp.pricingName] : null
    }
    exclusions: {
        onSubscription: (!empty(array(sp.exclusions.subscriptions)) || contains(array(sp.exclusions.subscriptions), subscriptionId))
        onResource: (!empty(array(sp.exclusions.resources)) || contains(array(sp.exclusions.resources), subscriptionId))
    }
}]

@batchSize(1)
resource PRICING 'Microsoft.Security/pricings@2023-01-01' = [for (pricing, index) in securityPricing: if (!(securityPricing[index].exclusions.onSubscription)) {
    name: pricing.name
    properties: pricing.properties
}]
