Login-AzureRmAccount

$subscriptionName = "your subscription"
Select-AzureRmSubscription -SubscriptionName $subscriptionName

$rgName = "your resource group name"
$vmName = "your VM Name"
$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName

#os disk
$vm.StorageProfile[0].OsDisk.DiskSizeGB = 500
#data disk
#$vm.StorageProfile[0].DataDisks[0].DiskSizeGB = 1023 

Update-AzureRmVM -ResourceGroupName $rgName -VM $vm
