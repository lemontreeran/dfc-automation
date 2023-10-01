param SecurityPricingInfo array

targetScope = 'subscription'

var subscriptionId = '${subscription().subscriptionId}'
var securityPricing = [for (spi, index) in SecurityPricingInfo: {
    name: spi.pricingName
    properties: {
        pricingTier: spi.pricingTier
        subPlan: contains(spi.subPlan, spi.pricingName) ? spi.subPlan[spi.pricingName] : null
        extensions: contains(spi.extensions, spi.pricingName) ? spi.extensions[spi.pricingName] : null
    }
    exclusions: spi.exclusions
}]

var exclusions = [for (sp, index) in securityPricing: {
    onSubscription: (!empty(array(sp.exclusions.subscriptions)) || contains(array(sp.exclusions.subscriptions), subscriptionId))
    onResource: (!empty(array(sp.exclusions.resources)) || contains(array(sp.exclusions.resources), subscriptionId))
}]

@batchSize(1)
resource PRICING 'Microsoft.Security/pricings@2023-01-01' = [for (pricing, index) in securityPricing: if (!(exclusions[index].onSubscription)) {
    name: pricing.name
    properties: pricing.properties
}]
