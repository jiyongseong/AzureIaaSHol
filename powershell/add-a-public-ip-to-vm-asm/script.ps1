Add-AzureAccount

$subscriptionName = "your subscription Name"
Select-AzureSubscription -SubscriptionName $subscriptionName

$serviceName = "cloud service name"
$vmName = "VM name"
$publicIpName = "public ip name"

Get-AzureVM -ServiceName $serviceName -Name $vmName | Set-AzurePublicIP -PublicIPName $publicIpName | Update-AzureVM