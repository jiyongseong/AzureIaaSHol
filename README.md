# Azure IaaS Hands on Lab
Micorosoft Azure에서 제공되는 IaaS(Infrastructure as a Service) 서비스들에 대한 Hands on Lab을 제공합니다.

### PowerShell

#### Virtual Machines
  * [Azure VM Disk 크기 조정 - ARM (PowerShell)](https://github.com/jiyongseong/AzureIaaSHol/tree/master/powershell/resize-disk-size) 
    - PowerShell을 이용하여, Azure VM의 OS 디스크 또는 데이터 디스크의 크기를 변경하는 방법을 설명합니다.
      - 설명은 __ARM(Azure Resource Manager)__ 을 기준으로 하고 있습니다.

  * [Azure VM Disk 크기 조정 - ASM (PowerShell)](https://github.com/jiyongseong/AzureIaaSHol/tree/master/powershell/resize-disk-size-asm) 
    - PowerShell을 이용하여, Azure VM의 OS 디스크 또는 데이터 디스크의 크기를 변경하는 방법을 설명합니다.
      - 설명은 __ASM(Azure Service Manager)__ 을 기준으로 하고 있습니다.

  * [Custom script를 이용하여 Azure VM에 언어 팩 설치하기 (PowerShell)](https://github.com/jiyongseong/AzureIaaSHol/tree/master/powershell/installing-language-packs)
    - Virtual Machine을 provision하면서, 언어 팩 설치를 자동화하는 custom script를 제공합니다. 

  * [Azure VM에 Instance Public IP 추가하기 (ASM)](https://github.com/jiyongseong/AzureIaaSHol/tree/master/powershell/add-a-public-ip-to-vm-asm)
    - Public IP를 설정하는 방법
    
### Resource templates

  * [SQL Server AlwaysOn Availability Group resource template (JSON)](https://github.com/jiyongseong/AzureIaaSHol/tree/master/resource_template/AzureResourceGroup-AlwaysOnCluster) 
    - Azure Resource Template를 이용하여 SQL Server AlwaysOn Availability Group을 생성하는 방법을 설명하고 있습니다.
      - 포털 또는 PowerShell cmdlet을 이용하는 경우보다, 좀 더 적은 노력 + 선언적 방식으로 생성할 수 있는 방법
      - 포털 또는 [Azure Quickstart Templates](https://github.com/Azure/azure-quickstart-templates)에서 생성 시에 오류가 발생되는 경우의 대안

  * [2 IIS VM & SQL VM 생성 템플릿 (JSON)](https://github.com/jiyongseong/AzureIaaSHol/tree/master/resource_template/2-iis-vms-sql-vm-template) 
    - Azure 상에 두 대의 IIS VM과 한 대의 SQL Server로 구성된 환경 구성을 위한 Azure Resource Template

  * [Virtual Machine 생성 시점에 Timezone 지정하기](https://github.com/jiyongseong/AzureIaaSHol/tree/master/resource_template/windows-vm-timezone) 
    - resource template를 이용하여 Azure Virtual Machine(Windows) 생성 시에, UTC가 아닌 다른 timezone을 설정하는 방법에 대해서 설명합니다.

**성지용([jiyongseong](https://github.com/jiyongseong))**
