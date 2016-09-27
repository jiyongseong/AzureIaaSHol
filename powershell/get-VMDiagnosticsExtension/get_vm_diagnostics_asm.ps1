Add-AzureAccount

$subscriptionName = "your subscription name"
$serviceName = "your cloud service name"
$vmName = "your vm name"
 
$configPath = "C:\temp\filename_asm.xml"
 
Select-AzureSubscription -SubscriptionName $subscriptionName

$vmContext = Get-AzureVM -ServiceName $serviceName -Name $vmName 

$extensionContext = Get-AzureVMDiagnosticsExtension -VM $vmContext
$publicConfiguration = $extensionContext.PublicConfiguration | ConvertFrom-Json
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($publicConfiguration.xmlcfg)) | Out-File -Encoding utf8 -FilePath $configPath