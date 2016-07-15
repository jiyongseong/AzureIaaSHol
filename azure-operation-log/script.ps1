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
