# Azure VM Disk 크기 조정(ARM)

Azure VM에 있는 OS 디스크 또는 데이터 디스크의 크기를 조정하는 PowerShell 스크립트 입니다.  
물론 Azure 포털에서도 VM > [일반] > [디스크] > 크기(GiB)에서 조정이 가능합니다만, 여러 디스크를 한번에 수정하는 작업은 상당한 노동력을 필요로 하죠.    

이런 경우에 PowerShell이 강력한 기능을 발휘합니다.

아래의 설명은 __ARM(Azure Resource Manager)__ 을 기준으로 하고 있습니다.

PowerShell 콘솔(powershell.exe)이나, PowerShell ISE(powershell_ise.exe)를 실행합니다.

먼저, 로그인을 합니다.
```PowerShell

Login-AzureRmAccount

```

다음에는 변경하려는 VM이 있는 구독(subscription)을 선택합니다.

```PowerShell
$subscriptionName = "your subscription"
Select-AzureRmSubscription -SubscriptionName $subscriptionName
```

다음에는 변경하려는 VM의 리소스 그룹과 VM의 이름을 통하여 VM 개체를 반환합니다.

```PowerShell
$rgName = "your resource group name"
$vmName = "your VM Name"
$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName
```

만약 변경하려는 디스크가 OS 디스크라면, 다음과 같이 기술합니다.
아래의 코드에서는 OS 디스크를 500GB로 변경하고 있습니다.


```PowerShell
$vm.StorageProfile[0].OsDisk.DiskSizeGB = 500
```

만약, 데이터 디스크를 변경하고 싶다면, 다음과 같이 사용하면 됩니다.
DataDisks[0]의 인덱스는 데이터 디스크의 인덱스 번호 입니다.

```PowerShell
$vm.StorageProfile[0].DataDisks[0].DiskSizeGB = 1023 
```

이제, VM 개체를 업데이트하여 변경사항을 적용합니다.

```PowerShell
Update-AzureRmVM -ResourceGroupName $rgName -VM $vm
```