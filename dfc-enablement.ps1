param (
    [Parameter(Mandatory = $true)]
    [String]$Region,

    [Parameter(Mandatory = $true)]
    [String]$SubscriptionId

    # [Parameter(Mandatory = $true)]
    # [String]$PricingTier

    # [Parameter(Mandatory = $true)]
    # [String]$ParametersFilePath
)

Set-AzContext -Subscription $SubscriptionId

# Write-Output "Deploying to $SubscriptionId in $Region using $ConfigurationFilePath"

# $Plans = @(
#     'StorageAccounts'
#     'VirtualMachines'
#     'SqlServers'
#     'AppServices'
#     'SqlServerVirtualMachines'
#     'KeyVaults'
#     'Dns'
#     'Arm'
#     'OpenSourceRelationalDatabases'
#     'Containers'
#     'CosmosDbs'
# )

# foreach ($Plan in $Plans) {
#     # $TemplateParameterObject = @{
#     #     pricingTier = $PricingTier
#     #     pricingName = $Plan
#     # }

#     $ParametersFileName = $Plan.ToLower()
#     $ParametersFilePath = "parameters/$($ParametersFileName).json"

#     Write-Output "Deployment Parameters File Path: $ParametersFilePath"

#     New-AzSubscriptionDeployment `
#       -Location $Region `
#       -TemplateFile "./dfc-plan.bicep" `
#       -TemplateParameterFile $ParametersFilePath `
#       -Verbose
# }

New-AzSubscriptionDeployment `
  -Location $Region `
  -TemplateFile "./dfc-plan.bicep" `
  -TemplateParameterFile "./parameters.json" `
  -Verbose
