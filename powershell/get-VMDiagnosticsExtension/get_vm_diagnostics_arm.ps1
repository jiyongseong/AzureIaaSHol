Login-AzureRmAccount

$subscriptionName = "your subscription name"
Select-AzureRmSubscription -SubscriptionName $subscriptionName

$resourceGroupName = "your resource group name"
$vmName = "your vm name"
$configPath = 'C:\temp\filename_arm.xml'

$extensionContext = Get-AzureRmVMDiagnosticsExtension -ResourceGroupName $resourceGroupName -VMName $vmName 
$publicConfiguration = $extensionContext.PublicSettings | ConvertFrom-Json
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($publicConfiguration.xmlcfg)) | Out-File -Encoding utf8 -FilePath $configPath