# Azure VM Disk 크기 조정(ASM)

Azure VM에 있는 OS 디스크 또는 데이터 디스크의 크기를 조정하는 PowerShell 스크립트 입니다.  

아래의 설명은 __ASM(Azure Service Manager)__ 을 기준으로 하고 있습니다.

PowerShell 콘솔(powershell.exe)이나, PowerShell ISE(powershell_ise.exe)를 실행합니다.

먼저, 로그인을 합니다.
```PowerShell

Add-AzureAccount

```

다음에는 변경하려는 VM이 있는 구독(subscription)을 선택합니다.

```PowerShell
$subscriptionName = "your subscription"
Select-AzureSubscription -SubscriptionName $subscriptionName
```

다음에는 변경하려는 디스크를 확인해야 합니다.  
먼저 OS 디스크의 경우에는 다음과 같이 확인할 수 있습니다.

```PowerShell
$serviceName = "your service name"
$vmName = "your VM name"
Get-AzureVM -ServiceName $serviceName -Name $vmName | Get-AzureOSDisk
```

위의 스크립트를 실행하면, 다음과 같은 결과가 출력됩니다. 여기서, DiskName을 복사합니다.
(반환 결과는 여러 분의 VM에 따라서 달라집니다. 아래는 예시입니다.).

![](https://jyseongfileshare.blob.core.windows.net/images/resize-disk-size0.jpg)

만약 변경하려는 디스크가 데이터 디스크라면, 다음과 같이 기술합니다.

```PowerShell
Get-AzureVM -ServiceName $serviceName -Name $vmName | Get-AzureDataDisk | SELECT LUN, DiskName | Sort-Object LUN
```

위의 스크립트를 실행하면, 다음과 같은 결과가 반환됩니다.
스크립트는 LUN 번호를 기준으로 정렬되어, 디스크의 이름을 반환합니다(반환 결과는 여러 분의 VM에 장착된 데이터 디스크에 따라서 달라집니다. 아래는 예시입니다.).

![](https://jyseongfileshare.blob.core.windows.net/images/resize-disk-size1.jpg)

OS 디스크와 마찬가지로, 변경하려는 디스크의 DiskName을 복사합니다.

다음에는 디스크 크기를 변경하기 위해서 VM을 중지합니다.

```PowerShell
Get-AzureVM -ServiceName $serviceName -Name $vmName  | Stop-AzureVM -Force
```

복사한 DiskName의 값을 다음의 ```$diskName``` 매개변수에 붙여 넣기 합니다.
아래에서는 디스크의 크기를 500GB로 변경하고 있습니다.

```PowerShell
$diskName = "disk name"
Update-AzureDisk –DiskName $diskName -Label "ResiZedOS" -ResizedSizeInGB 500
```

마지막으로, VM을 시작합니다.

```PowerShell
Get-AzureVM -ServiceName $serviceName -Name $vmName | Start-AzureVM
```