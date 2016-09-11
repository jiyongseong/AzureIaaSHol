# Azure VM에 Instance Public IP 추가하기 (ASM)

Azure Service Management(Classic) VM에 대해서 Public IP를 설정하는 방법은 다음과 같습니다.

```powershell
Add-AzureAccount

$subscriptionName = "your subscription Name"
Select-AzureSubscription -SubscriptionName $subscriptionName

$serviceName = "cloud service name"
$vmName = "VM name"
$publicIpName = "public ip name"

Get-AzureVM -ServiceName $serviceName -Name $vmName | Set-AzurePublicIP -PublicIPName $publicIpName | Update-AzureVM
```

[Set-AzurePublicIP](https://msdn.microsoft.com/en-us/library/mt589113.aspx)