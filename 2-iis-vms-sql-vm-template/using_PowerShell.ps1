Login-AzureRmAccount

$subscriptionName = "your subscription name"
Select-AzureRmSubscription -SubscriptionName $subscriptionName

$resourcGroupname = "resouce group name"
$location = "location - westus"
$storageAccountName = "storage account for template file"
$fileLocation = "template file location"
$templateFile = $fileLocation+"templates\azuredeploy.json"
$templateParametersFile = $fileLocation + "templates\azuredeploy.parameters.json"

cd $fileLocation

New-AzureRmResourceGroup -Name $resourcGroupname -Location $location -Force

./Deploy-AzureResourceGroup.ps1 -StorageAccountName $storageAccountName  -ResourceGroupName $resourcGroupname `
                                    -ResourceGroupLocation $location `
                                    -TemplateFile $templateFile `
                                    -TemplateParametersFile $templateParametersFile `
                                    -ArtifactStagingDirectory '.' -DSCSourceFolder '.\DSC' -UploadArtifacts 