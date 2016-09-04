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


