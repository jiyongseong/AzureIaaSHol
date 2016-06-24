# SQL Server AlwaysOn Availability Group resource template

Azure의 [Marketplace](https://azure.microsoft.com/en-us/marketplace/virtual-machines/)에는 다양한 제품들이 미리 설치되어 있는 이미지들을 제공하고 있습니다.

그 중에 SQL Server 역시도 다양한 이미지들이 제공되고 있습니다.

SQL Server를 사용하는 경우, 안정적인 시스템 운영을 위해서 SQL Server의 AlwaysOn Availability Group을 구성할 것을 권장합니다.
Azure에서 SQL Server AlwaysOn Availability Group은 다양한 방법으로 구성할 수 있습니다.

예를 들면, 가상 네트워크, 가상 컴퓨터, 저장소 계정, 부하 분산기 등등을 직접 포털에서 구현([Configure Always On availability group in Azure VM manually - Resource Manager](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-portal-sql-alwayson-availability-groups-manual/))할 수도 있고, PowerShell을 이용하여 하나씩 구성할 수도 있습니다.
하지만, 이와 같이 하나씩 생성을 하는 경우 AlwaysOn Availability Group 구성에 많은 시간이 소요될 수도 있고, 실수로 리소스를 잘못 생성할 수도 있다는 단점이 있습니다.
조금 더 안정적이고 작은 시간만으로도 AlwaysOn Availability Group을 생성할 수 있는 방법은 리소스 템플릿을 이용하는 것입니다.

먼저, 포털을 이용한 방법을 들 수 있습니다.
포털을 이용한 방법은 다음의 링크([Configure Always On availability group in Azure VM automatically - Resource Manager](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-portal-sql-alwayson-availability-groups/))에서 잘 설명이 이루어지고 있습니다.
**반드시 영문으로 보셔야 합니다.**

또는, 직접 리소스 템플릿을 수정하여 사용하는 방법도 있습니다.
[Azure Quickstart Templates](https://github.com/Azure/azure-quickstart-templates)에서 "AlwaysOn"으로 검색을 하면 다양한 리소스 템플릿들이 있습니다.

근간에 포털 또는 github에서 제공되는 리소스 템플릿을 이용하는 경우, 다양한 원인으로 SQL Server AlwaysOn Availability Group 생성에 실패하는 경우가 많이 보여지고 있습니다.
예를 들어, 포털에서 생성하는 경우에는 DC에 대한 DSC 스크립트가 실패 한다거나, 장시간의 스크립트 실행으로 인해서 timeout 오류가 발생되기도 합니다.

github의 [Create a SQL Server 2014 Always On Availability Group in an existing Azure VNET and an existing Active Directory instance](https://github.com/Azure/azure-quickstart-templates/tree/875d139c16c9c023dce519e6dd48c707e3473346/sql-server-2014-alwayson-existing-vnet-and-ad) 리소스 템플릿의 경우에는 JSON에 정의된 DSC 스크립트 경로가 깨져 있어 생성에 실패하고 있습니다.

상기의 방법으로 실패하는 경우, 다음의 리소스 템플릿을 이용해보시기 바랍니다.

## 사용 방법

1. 소스코드를 다운로드 하여 Visual Studio에서 엽니다.
2. 프로젝트 파일에서 오른쪽 마우스를 클릭하고, [Deploy] > [New Deployment]를 선택합니다.
 ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster01.jpg)
3. 아래의 그림과 같은 창이 보여지게 됩니다.
  * 배포하려는 Azure 계정으로 로그인을 합니다.
  * 배포하려는 구독을 선택합니다.
  * 배포할 리소스 그룹을 선택하거나, 새로운 리소스 그룹을 생성할 수 있습니다. 여기서는 새로 만들기를 선택하겠습니다.
 ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster02.jpg)
4. 생성할 리소스 그룹의 이름과 지역을 선택합니다.
 ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster03.jpg)
5. [Edit Parameters] 버튼을 클릭합니다. 
  ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster04.jpg)
6. 각종 매개변수를 입력 또는 수정합니다. 아래의 그림에서 붉은색으로 표시된 부분은 변경해서는 안됩니다.
  ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster05.jpg)
7. [Deploy] 버튼을 눌러서, 배포를 시작합니다.
  ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster06.jpg)
8. 템플릿에 대한 유효성 검사가 완료되고 나면, Azure로 배포가 시작됩니다.
  ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster07.jpg)
9. 배포가 시작되면, Azure 포털에서도 배포 진행 상황을 모니터링할 수 있습니다.
  ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster08.jpg)
10. 배포 진행 상황에 대한 상세 내역도 확인이 가능합니다.
  ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster09.jpg)
11. 배포 완료!
  ![AO](https://jyseongfileshare.blob.core.windows.net/images/AzureResourceGroup-AlwaysOnCluster10.jpg)

