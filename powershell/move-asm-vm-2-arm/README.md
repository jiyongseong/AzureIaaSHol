# Azure Classic VM을 ARM VM으로 이동하기

Classic(ASM, Azure Service Management)에서 만들어진 VM을 ARM(Azure Resource Manager) 형식으로 변환해야 하는 방법은 다음과 같습니다.

일부 인터넷에 공개된 문서에서는 VM을 삭제(OS/Data Disk는 그대로 두고 VM을 삭제)하고, PowerShell을 이용하여 ARM의 VM을 생성하는 방법을 설명하고 있기도 합니다만, 이보다는 좀 더 안정적인 방식으로 VM을 마이그레이션 할 수 있는 방법도 제공이 되고 있습니다.

좀 더 자세한 내용은 다음의 링크에서 설명이 되고 있습니다.

[Migrate IaaS resources from classic to Azure Resource Manager by using Azure PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-ps-migration-classic-resource-manager)

### 사전 조건

먼저 최신의 Azure PowerShell이 필요합니다. 만약 이미 설치가 되어 있지 않다면, 다음의 링크에서 다운로드 하여 설치하시기 바랍니다.

[https://azure.microsoft.com/en-us/downloads/](https://azure.microsoft.com/en-us/downloads/)

이후의 작업들은 [Move-AzureVirtualNetwork](https://docs.microsoft.com/en-us/powershell/servicemanagement/Azure.Service/v2.1.0/Move-AzureVirtualNetwork)라는 cmdlet과 [Azure 포털](http://portal.azure.com/)을 이용하게 됩니다.

### Classic VM 구성

기존 구성은 다음과 같다고 가정을 하도록 하겠습니다.

예저의 환경은
- 가상 네트워크가 구성되어 있고, : myVnet1
- 가상 네트워크에는 다음과 같이 3개의 서브넷이 구성되어 있다.
    - infraVM 서브넷
    - frontVM 서브넷
    - backendVM 서브넷
- VM은 3개의 VM이 생성되며, VM들은 별도의 서브넷에 생성이 됩니다.
    - infraVM > infraVM 서브넷
    - frontVM > frontVM 서브넷
    - backendVM > backendVM 서브넷
- VM들은 하나의 클라우드 서비스에 생성되어 있다.

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-01.png)

예제를 실제 구현한 화면은 다음과 같습니다. 먼저, 클라우드 서비스의 구성은 다음과 같습니다.

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-02.png)

가상 네트워크의 구성은 다음과 같습니다.

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-03.png)

각 VM의 VHD들은 하나의 storage account를 사용하도록 구성되어 있습니다.

### Classic VM 마이그레이션

이제는 VM을 마이그레이션 할 차례입니다. VM들이 가상 네트워크에 있는 경우에는 가상 네트워크를 마이그레이션 하면, 가상 네트워크 안에 있는 VM들도 같이 마이그레이션 됩니다.

가상 네트워크가 없이 생성된 VM의 경우에는 [Move-AzureService](https://docs.microsoft.com/en-us/powershell/servicemanagement/Azure.Service/v2.1.0/Move-AzureService)라는 cmdlet을 사용하게 됩니다. 이번 설명은 가상 네트워크 안에 생성된 VM들을 마이그레이션 하는 방법을 설명합니다.

다음의 PowerShell 스크립트를 이용하여, 가상 네트워크를 마이그레이션 합니다.

```PowerShell

Add-AzureAccount
 
$subscriptionName = "your subscription"
Select-AzureSubscription -SubscriptionName $subscriptionName
 
$vnetName = "your virtual network"
 
$validate = Move-AzureVirtualNetwork -Validate -VirtualNetworkName $vnetName
$validate.ValidationMessages
 
Move-AzureVirtualNetwork -Prepare -VirtualNetworkName $vnetName
 
Move-AzureVirtualNetwork -Commit -VirtualNetworkName $vnetName

```

위의 스크립트에서는 두 가지 매개 변수의 값을 변경 해주어야 합니다.

- $subscriptionName = "your subscription"
- $vnetName = "your virtual network"

마이그레이션이 완료되면, 두 개의 새로운 Resource Group이 생성됩니다.

- "가상 네크워크 이름" – Migrated
- "클라우드 서비스 이름" – Migrated

예제에서는 myVnet1이라는 가상 네트워크를 사용하였기 때문에, 다음과 같은 Resource Group이 생성됩니다.
해당 Resource Group에는 가상 네트워크 리소스만 마이그레이션됩니다.

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-04.png)

클라우드 서비스는 jyseongasmvms라는 이름으로 생성을 하였습니다. 클라우드 서비스의 리소스들은 다음과 같은 Resource Group으로 마이그레이션이 됩니다.
해당 Resource Group에는 VM, NIC, Availability set, Public IP, Load Balancer 등, VM과 관련된 리소스들이 마이그레이션 됩니다.

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-05.png)

마이그레이션이 완료되면, 구포털에서는 해당 리소스가 사라지게 됩니다.

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-06.png)

### 저장소 계정 이동

이제 VM 및 가상 네트워크와 같이, VM을 운영하는데 필요한 리소스들은 Classic에서 ARM으로 이동이 완료되었습니다.

하지만, 아직 이동되지 않은 리소스가 남아 있습니다. VM의 운영체제 디스크와 데이터 디스크는 그대로 Classic(V1) 저장소 계정에 남아 있습니다.

마지막으로, 저장소 계정을 ARM으로 이동해주어야 합니다.

다음의 PowerShell 스크립트를 이용하여 저장소 계정을 마이그레이션 합니다.

```PowerShell
$storageAccountName = "your storage account name"
$validate = Move-AzureStorageAccount -Prepare -StorageAccountName $storageAccountName
$validate.ValidationMessages

Move-AzureStorageAccount -Commit -StorageAccountName $storageAccountName 
```

저장소 계정도 마찬가지로, "저장소 계정 이름" - Migrated라는 Resource Group으로 마이그레이션이 됩니다.

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-07.png)

마이그레이션이 완료되면, 저장소 계정의 속성 등을 다시 한번 확인해보시기 바랍니다(특히, 복제 유형).

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-08.png)

### (Optional) Resource Group 정리

마지막 작업은 반드시 필요한 작업은 아닙니다. 마이그레이션 작업에 의해서 생성된 Resource Group의 명칭이 "-Migrated"라는 형식을 가지고 있습니다. 이는 통상적으로 사용되는 명칭이 아니거나, 다른 명칭을 사용하려는 경우가 있습니다. 현재 Azure에서는 Resource Group의 이름을 변경하는 것이 허용되지 않기 때문에, 원하는 이름의 Resource Group을 새로 생성하고, 해당 Resource Group으로 마이그레이션한 리소스들을 이동(Move)해 주어야 합니다.

Resource Group 간의 리소스 이동은 포털(http://portal.azure.com)으로 간단하게 이동이 가능합니다.

포털에서 Resource Group을 선택하고, 상단에 있는 Move 버튼을 이용하여 다른 Resource Group으로 리소스의 이동이 가능합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/move-asm-vm-2-arm-09.png)
