# Azure 운영 로그 확인하기

Azure 상에서 이루어지는 모든 작업은 Azure의 데이터센터에 로그로 기록이 이루어집니다.

물론, 포털에서도 다음과 같이 검색이 가능합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/azure-operation-log-01.png)

실제 검색 화면은 아래와 같습니다.

![](https://jyseongfileshare.blob.core.windows.net/images/azure-operation-log-02.png)

Azure 포털에서 제공되는 기능은 그대로 Rest API 또는 PowerShell, Cross platform command line interface로도 제공이 됩니다.

아래의 PowerShell 스크립트는, 이러한 운영 로그들을 로컬에 csv 파일 형식으로 저장하여 쉽게 로그를 볼 수 있는 방법을 제공합니다.

Azure 상에서 발생된 리소스들에 대한 작업(VM을 deallocate한다던지, 리소스를 삭제 또는 생성, 변경) 로그들이 필요한 경우가 있습니다.

예를 들면, 특정 리소스를 누가, 어떤 IP 주소에서 삭제했는지, VM을 생성하면서 발생된 오류 내용을 좀 더 자세하게 보고 싶은 경우가 이에 해당합니다.

```PowerShell
Login-AzureRmAccount

$subscriptionName = "your subscription name"
$resourceGroup = "your resource group name"
$path = "C:\temp\AzureLog@"+(Get-Date).ToShortDateString()+".csv"

Select-AzureRmSubscription -SubscriptionName $subscriptionName

(Get-AzureRmLog -ResourceGroup $resourceGroup -StartTime (Get-Date).AddDays(-1) -DetailedOutput) | select ResourceGroupName,ResourceProviderName,ResourceId, Status, SubmissionTimestamp, SubscriptionId, SubStatus, `
caller, @{Name="caller_IPAddress"; Expression = {($_.Claims.Content.Get_Item("ipaddr"))}}, EventChannels, `
@{Name="Authorization.Scope"; Expression = {($_.Authorization.Scope)}}, `
@{Name="Authorization.Action"; Expression = {($_.Authorization.Action)}}, `
@{Name="Authorization.Role"; Expression = {($_.Authorization.Role)}}, `
@{Name="Authorization.Condition"; Expression = {($_.Authorization.Condition)}},`
EventName, Category, EventTimestamp, Id, Level, OperationName, `
@{Name="Status Code"; Expression = {($_.Properties.Content.Get_Item("statusCode"))}},`
@{Name="Status Message"; Expression = {($_.Properties.Content.Get_Item("statusMessage"))}}  | Export-Csv -Path $path -NoTypeInformation

```

먼저, PowerShell command line(powershell.exe) 또는 PowerShell ISE(PowerShell_ise.exe)를 실행하고, 로그인을 합니다.

```PowerShell
Login-AzureRmAccount
```

다음에는 여러 분의 구독 정보(```$subscriptionName```), 리소스 그룹 이름(```$resourceGroup```), 파일을 저장할 위치(```$path```) 등을 지정합니다.

```PowerShell
$subscriptionName = "your subscription name"
$resourceGroup = "your resource group name"
$path = "C:\temp\AzureLog@"+(Get-Date).ToShortDateString()+".csv"

Select-AzureRmSubscription -SubscriptionName $subscriptionName
```

다음에는 로그를 검색할 범위를 지정합니다. 위의 스크립트에서는 지금 시점을 기준으로 하루 전(```AddDays(-1)```)을 지정하고 있습니다.

한시간 전을 설정하고 싶은 경우에는, ```AddHours(-1)```로 변경하시거나,

특정 시점을 지정하고 싶으신 경우에는 ```-StartTime```과 ```-EndTime```을 지정하면 됩니다. ```-EndTime```은 현재 시점을 기준으로 15일 이전까지만 지정할 수 있습니다. 

모든 설정이 완료하고 스크립트를 실행하면, ```$path```에 지정한 위치에 로그 파일이 저장됩니다.

해당 파일을 Excel을 이용하여 열고, 표 형식으로 변환을 하면 쉽게 데이터를  filtering 할 수 있습니다.

예를 들어, [Status]가 "Failed"만을 filtering을 하여, 작업이 실패한 데이터만 볼 수 있습니다.

![](https://jyseongfileshare.blob.core.windows.net/images/azure-operation-log-03.png)

[Status Message] 항목을 보면, 해당 작업이 오류 메시지의 내용을 확인할 수 있습니다.

![](https://jyseongfileshare.blob.core.windows.net/images/azure-operation-log-05.png)

다음의 문서들의 내용을 참고하였습니다.

- [Audit operations with Resource Manager](https://azure.microsoft.com/en-us/documentation/articles/resource-group-audit/)
- [View deployment operations with Azure PowerShell](https://github.com/Azure/azure-content/blob/master/articles/resource-manager-troubleshoot-deployments-powershell.md)
- [Get-AzureRmLog](https://msdn.microsoft.com/en-us/library/mt603617.aspx)