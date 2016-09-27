Login-AzureRmAccount

$subscriptionName = "your subscription name"

Select-AzureRmSubscription -SubscriptionName $subscriptionName

$resourceGroupName = "your resource group name"
$pipName = "public ip name"

$pip = Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName -Name $pipName
$pip.IdleTimeoutInMinutes = 10
Set-AzureRmPublicIpAddress -PublicIpAddress $pip 
