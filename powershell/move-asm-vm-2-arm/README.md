# Azure Classic VM을 ARM VM으로 이동하기

Classic(ASM, Azure Service Management)에서 만들어진 VM을 ARM(Azure Resource Manager) 형식으로 변환해야 하는 방법은 다음과 같습니다.

일부 인터넷에 공개된 문서에서는 VM을 삭제(OS/Data Disk는 그대로 두고 VM을 삭제)하고, PowerShell을 이용하여 ARM의 VM을 생성하는 방법을 설명하고 있기도 합니다만, 이보다는 좀 더 안정적인 방식으로 VM을 마이그레이션 할 수 있는 방법도 제공이 되고 있습니다.

좀 더 자세한 내용은 다음의 링크에서 설명이 되고 있습니다.

[Migrate IaaS resources from classic to Azure Resource Manager by using Azure PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-ps-migration-classic-resource-manager)

#### 사전 조건

먼저 최신의 Azure PowerShell이 필요합니다. 만약 이미 설치가 되어 있지 않다면, 다음의 링크에서 다운로드 하여 설치하시기 바랍니다.

[https://azure.microsoft.com/en-us/downloads/](https://azure.microsoft.com/en-us/downloads/)

이후의 작업들은 [Move-AzureService](https://docs.microsoft.com/en-us/powershell/servicemanagement/Azure.Service/v2.1.0/Move-AzureService)라는 cmdlet과 [Azure 포털](http://portal.azure.com/)을 이용하게 됩니다.

#### Classic VM 구성

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

#### Classic VM 마이그레이션
