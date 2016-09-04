# Custom script를 이용하여 Azure VM에 언어 팩 설치하기 (PowerShell)

Azure Virtual Machine은 기본적으로 영문 버전이  설치가 됩니다. 이런 저런 이유로 인해서, 종종 한글 언어 팩을 설치하시는 경우가 있습니다.

VM을 provisioning 하면서 언어 팩을 설치하는 것은 불가능하며, VM 생성이 완료된 이후에 직접 RDP를 통해서 언어팩을 설치해주셔야 하는 불편함이 있습니다.

VM에서 직접 언어 팩을 설치하는 과정은 다음의 링크를 참고하시기 바랍니다.

[제어판을 사용하여 국가별 설정 구성](https://technet.microsoft.com/ko-kr/library/hh825705.aspx#ControlPanel)

소수의 VM의 경우에는 이런 과정이 문제가 되지 않지만, 여러 대의 VM을 생성하시는 경우에는 많은 시간을 필요로 하고, VM마다 작업을 해주어야 한다는 불편함이 있습니다.

이러한 과정을 Azure VM의 custom script를 이용하면 간편하게 설치가 가능합니다.

(제가 찾지 못한 것인지는 모르겠습니다만,) Windows Server 제품군의 언어 팩을 다운로드할 수 있는 경로가 외부로 노출되어 있지는 않습니다. 따라서, 아래의 내용은 MSDN 구독 계정을 가지신 분만 가능한 시나리오 입니다(또는 언어 팩 파일을 DVD로 가지신 분도 가능합니다).

먼저 [MSDN subscriber download 사이트](https://msdn.microsoft.com/en-us/subscriptions/downloads/)로 이동을 하고, 로그인을 합니다.

상단의 메뉴에서 [Subscriber download] > Product Categories > Operating Systems > 원하시는 운영 체제를 선택합니다(여기서는 Windows Server 2012 R2를 선택하였습니다).

![](https://jyseongfileshare.blob.core.windows.net/images/installing-language-packs-01.png)

메뉴를 선택하면, 해당 버전의 목록들이 보여집니다. 여기서 Language Pack을 다운로드 합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/installing-language-packs-02.png)

다운로드가 완료되면, ISO로된 파일의 압축을 풀어서 Azure Storage Account로 업로드합니다. 이때, 올리는 Azure Storage Account의 Container의 access policy는 "BLOB"로 합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/installing-language-packs-03.png)

이제, 첨부된 "installingLanguagePack.ps1" PowerShell 스크립트를 로컬로 다운로드 하고, PowerShell ISE나 편집기로 해당 파일을 엽니다.

아래의 스크립트에서 다음의 내용들을 환경에 맞게 수정합니다.

1. ```PowerShell $storageAccountName = "your storage account name" ```
2. 하위 경로들
```PowerShell
    if ($ver.StartsWith("6.3")) #Windows Server 2012 R2
    {
        $src = "https://$storageAccountName.blob.core.windows.net/languagepacks/windowsserver2012r2/ko-kr/lp.cab"
    }
    if ($ver.StartsWith("6.2")) #Windows Server 2012 
    {
        $src = "https://$storageAccountName.blob.core.windows.net/languagepacks/windowsserver2012/ko-kr/lp.cab"
    }
````

전체 PowerShell 스크립트는 다음과 같습니다.

```PowerShell
$folder = New-Item -Path "D:\lang\" -ItemType directory
$ver = [string](Get-WmiObject win32_operatingsystem).version

$storageAccountName = "your storage account name"

if ($ver.StartsWith("6.3")) #Windows Server 2012 R2
{
    $src = "https://$storageAccountName.blob.core.windows.net/languagepacks/windowsserver2012r2/ko-kr/lp.cab"
}
if ($ver.StartsWith("6.2")) #Windows Server 2012 
{
    $src = "https://$storageAccountName.blob.core.windows.net/languagepacks/windowsserver2012/ko-kr/lp.cab"
}

$dest = $folder.FullName + "\lp.cab"

Import-Module BitsTransfer
Start-BitsTransfer -Source $src -Destination $dest

$command="C:\Windows\System32\dism.exe /online /add-package /packagepath:" + $dest
Invoke-Expression $command

Add-Content 'D:\lang\languageSettings.ps1' 'Set-WinSystemLocale -SystemLocale "ko-KR"
Set-WinUILanguageOverride -Language "ko-KR"

$UserLang = Get-WinUserLanguageList
$UserLang.Add("ko-KR")
Set-WinUserLanguageList -LanguageList $UserLang -Force

logoff
'
Set-Location -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
Set-ItemProperty -Path . -Name langSet -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -File "D:\lang\languageSettings.ps1"'

Restart-Computer -Force
```

이제, Azure Portal을 열고, 새로운 VM을 만들기를 시작합니다(New > Virtaul Machine > 원하는 이미지 - Windows Server여야 하겠죠).

기본 정보들을 입력하고, 3번째 단계인 Settings에서 다음과 같이 선택합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/installing-language-packs-04.png)

Add extention > custom script extention > Create를 선택합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/installing-language-packs-05.png)

마지막으로 Install extention에서는 다운로드한 "installingLanguagePack.ps1"를 선택하고, 연속해서 Create 버튼을 클릭합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/installing-language-packs-06.png)

VM 생성이 완료되면, RDP로 접속을 합니다. 

RDP 접속이 되면, 자동으로 언어팩 설치가 완료되고 (화면의 언어 설정을 변경하기 위해서) __RDP에서 로그 오프__ 합니다.

![](https://jyseongfileshare.blob.core.windows.net/images/installing-language-packs-08.png)


다시 RDP로 접속을 하면, 한글 언어 팩이 적용된 화면이 보여지게 됩니다.

![](https://jyseongfileshare.blob.core.windows.net/images/installing-language-packs-07.png)