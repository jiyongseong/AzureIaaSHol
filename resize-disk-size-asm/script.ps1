Add-AzureAccount

$subscriptionName = "your subscription"
Select-AzureSubscription -SubscriptionName $subscriptionName

$serviceName = "your service name"
$vmName = "your VM name"
Get-AzureVM -ServiceName $serviceName -Name $vmName | Get-AzureOSDisk

Get-AzureVM -ServiceName $serviceName -Name $vmName | Get-AzureDataDisk | SELECT LUN, DiskName | Sort-Object LUN

Get-AzureVM -ServiceName $serviceName -Name $vmName  | Stop-AzureVM -Force

$diskName = "disk name"
Update-AzureDisk –DiskName $diskName -Label "ResiZedOS" -ResizedSizeInGB 500

Get-AzureVM -ServiceName $serviceName -Name $vmName | Start-AzureVM
