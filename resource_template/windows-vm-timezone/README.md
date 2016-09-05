# Virtual Machine 생성 시점에 Timezone 지정하기

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjiyongseong%2FAzureIaaSHol%2Fmaster%2Fresource_template%2Fwindows-vm-timezone%2Ftemplates%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjiyongseong%2FAzureIaaSHol%2Fmaster%2%2Fresource_template%2Fwindows-vm-timezone%2Ftemplates%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

Azure Virtual Machine의 시간대는 기본적으로 UTC를 기준으로 생성이 이루어집니다.

PowerShell을 이용하는 경우, [Add-AzureProvisioningConfig](https://msdn.microsoft.com/en-us/library/azure/dn495299.aspx)라는 cmdlet의 -TimeZone의 매개변수에 사용하려는 Timezone을 지정하면 해당 Timezone을 사용하는 Virtual Machine이 생성됩니다.

***Timezone 설정은 Winodws VM에서만 설정 가능합니다.*** 

Azure Resourc Manager template을 이용하여 Virtual Machine을 생성하는 경우에도 Timezone을 지정할 수 있습니다.

Timezone 지정은 다음과 같이 수행이 가능합니다.

Azure Resource Manager template에서 Virtual Machine의 osProfile > windowsConfiguration 항목에서

```json
"osProfile": {
    "computerName": "[parameters('virtualMachineName')]",
    "adminUsername": "[parameters('adminUsername')]",
    "adminPassword": "[parameters('adminPassword')]",
    "windowsConfiguration": {
        "provisionVmAgent": "true",
        "timeZone": "Korea Standard Time"
    }
```

다음과 같이, Timezone을 추가하면 됩니다. 아래에서는 한국 표준 시간대(Korea Standard Time)을 지정하였습니다.

```json
"windowsConfiguration": {
    "provisionVmAgent": "true",
    "timeZone": "Korea Standard Time"
}
```

Virtual Machine 생성/갱신 시점에 사용할 수 있는 REST API 속성들은 다음의 문서를 참고하시기 바랍니다.

[Microsoft Azure > Azure Reference > Virtual Machines REST > Create or update a VM](https://msdn.microsoft.com/en-us/library/azure/mt163591.aspx)