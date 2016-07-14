# 2 IIS VM & SQL VM 생성 템플릿

Azure 상에 두 대의 IIS VM과 한 대의 SQL Server로 구성된 환경 구성을 위한 Azure Resource Template

템플릿 상의 리소스 관계는 다음과 같이 구성되어 있습니다.

![](https://jyseongfileshare.blob.core.windows.net/images/2-iis-vms-sql-vm-template-01.png)

일반적인 형태로 보면 다음과 같은 구조로 볼 수 있습니다.

![](https://jyseongfileshare.blob.core.windows.net/images/2-iis-vms-sql-vm-template-02.png)

프로젝트 파일을 다운로드 받아서, Visual Studio를 이용하여 프로젝트를 시작합니다.

솔루션 탐색기에서 "2-iis-vms-sql-vm-template" 프로젝트에서 오른쪽 마우스를 클릭하고, [Deploy] > [New Deployment]를 선택합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/2-iis-vms-sql-vm-template-03.png)

다음과 같이, [Deploy to Resource Group] 화면이 보여지면, [Template parameters file]에서 "azuredeploy.parameters.json"을 선택하고,

![](https://jyseongfileshare.blob.core.windows.net/images/2-iis-vms-sql-vm-template-04.png)

[Edit Parameters] 버튼을 클릭합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/2-iis-vms-sql-vm-template-05.png)

상단에 있는 세 가지 정보(저장소 이름, 관리자 이름, 관리자 비밀 번호)를 입력하고 [Save] 버튼을 눌러서 배포를 시작합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/2-iis-vms-sql-vm-template-06.png)
