**Azure Diagnostics를 이용한 로그인 정보 로깅하기**

Azure VM으로 RDP/SSH 프로토콜을 이용한 원격 접속에 대한 정보는 각
운영체제별(Windows/Linux)로 시스템 로그(Event Log/syslogs)에 기록이 됩니다.
Azure VM에서는 해당 시스템 로그(Event Log/syslogs)를 Azure Diagnostics logs 기능을 이용하여 Storage Account의 Table과 Blob stroage로 기록하도록 할 수 있습니다.

Diagnostics Log에 대한 좀 더 상세한 정보는 아래의 공식 문서를 참고하시기 바랍니다.

-   Azure 리소스에서 로그 데이터 수집 및 소비
    (<https://docs.microsoft.com/ko-kr/azure/monitoring-and-diagnostics/monitoring-overview-of-diagnostic-logs>)
 
운영 체제별로 로깅 방식이 상이함에 따라서, Azure에서는 운영 체제별(Windows/Linux)로 별도의 Agent를 제공하고 있으며, Windows용 Agent는 WAD(Windows Azure Diagnostics), Linux용은 Linux Azure Diagnostics(LAD)라고 부르고 있습니다.

WAD/LAD는 다양한 방식으로 설정이 가능한데, Azure Portal(https://portal.azure.com)에서 UI를 통하여 설정할 수 있으며, CLI/PowerShell과 같이 명령을 이용하는 방법, Azure Template를 통한 설정방법 등이 있습니다.

**Windows VM 설정 방법**

Azure Portal을 이용한 설정 방법은 아래와 같습니다. 먼저, Windows VM에 대한 설정 방법을 설명하고, 뒤이어 Linux VM에 대한 설정 방법을 공유드리겠습니다.

Azure Portal(https://portal.azure.com)에 접속하여, 설정을 원하는 VM을 선택합니다.
좌측 메뉴에서 Monitoring 항목 아래의 Diagnostics settings를 선택합니다.

![Machine generated alternative text: WindowsVM Virtual machine p Search (Ctrl +19 Change tracking Configuration management . Run command Monitoring Insights (preview) Alerts Metrics Diagnostics settings Advisor recommendations Logs (preview) Connection monitor Start Connect Resource group Change) UbuntuLad Status Running Location Korea South Subscription (change) Azure Demo Subscription ID Tags (change) Click here to add tags Show data for last: 1 hour Restart 6 hours Stop 12 hours ](media/3a199c3945103662c43731f97346fba7.png)

다음과 같은 화면이 보여지면, "Enable guest-level monitoring" 버튼을 클릭합니다.

![Machine generated alternative text: WindowsVM - Diagnostics settings Virtual machine earch (Ctrl+D lange tracking infiguration management . In command 'ring ;ights (preview) arts etrics agnostics settings Ivisor recommendations gs (preview) innection monitor « Save X Discard Overview Performance counters Logs Crash dumps Sinks Agent Azure Monitoring collects host-level metrics software. For more insight into this virtual mal Diagnostics agent. You can also send diagnosi To get started now, click the button below: Enable guest-level monitoring Already know what you're doing? You can cus remove data types to collect at any time. ](media/fa7014f908a92079214b44385c2e0bcb.png)

설정이 완료되면, 아래와 같은 화면이 보여지게 됩니다. Azure에 의해서 ubuntuladdiag564라는 Storage Account가 자동으로 생성됩니다.
상단의 메뉴에서 Logs 메뉴를 선택합니다.

![Machine generated alternative text: Overview Performance counters Performance counters Collecting data for these counters: • CPU • Memory • Disk • Network Configure performance counters Event logs Collecting data for these logs: Application: Critical, Error, Warning • Security. Audit failure System: Critical, Error, Warning Configure event logs Directories Not configured. Configure directories Crash dumps Not collecting memory dumps. Configure crash dumps Sinks Diagnostic data is not being sent to any sinks. Logs Crash dumps Sinks Agent Configure sinks Agent Diagnostic data is bein ubuntuladdiag564 nt to this storage account: ](media/fdd9f5be1380bed4fd4e52a2a1266aab.png)

다음과 같은 화면이 보여지면, Security 항목의 Audit Success 체크박스를 선택하고, 상단의 Save 버튼을 클릭합니다.

![](media/369bbae46489af2f18f8566907df6f17.png)

저장이 완료되면, RDP를 이용하여 해당 VM에 로그인을 합니다. 로그인이 성공적으로 이루어지면, 로그인에 대한 정보는 Windows Server의 Event Log에 기록이 되고, 해당 Event Log는 Windows Azure Diagnostics에 의해서 Storage account로 복사됩니다.

Event Log에 기록된 로그는 아래와 같습니다.

![Machine generated alternative text: Event Properties - Event 4624, Microsoft Windows security auditing. General Details Linked Logon ID: Network Account Name: Network Account Domain: - Logon GUID: Process Information: Process ID: Process Name: Network Information: Workstation Name: {00000000-0000-0000-0000-000000000000} sparkclient-win Source Network Address: 167.220.232.83 Source Port: Detailed Authentication Information: Logon Process: User32 Authentication Package: Negotiate Transited Services: Log Name: Source Event ID: Security Microsoft WInd0ws security Information N/A Info Logged: 11/16/2018 252:40 AM Task Category Logon Keywords: Computer. Audit Success sparkclient-win More Information: Event Log Online Help ](media/c7dcdd31cc9841f7d36fabb5ff17fb07.png)

Azure Storage Explorer(https://azure.microsoft.com/en-us/features/storage-explorer/)를 열고, 앞서 자동으로 생성된 Storage account를 선택합니다.
해당 storage account 하위에 있는 Tables 항목을 확장하면, WADWindowsEventLogsTable이라는 Table Storage가 보여지게 됩니다. 해당 Table을 클릭합니다.

![Machine generated alternative text: Storage Acc • ts ;x4335xaef krc iag295 ubuntuladdiafiifi4 Blob Containers File Shares Queues Tables SchemasTable WADPerformanceCountersTable WADWindowsEventLogsTable ](media/a8c5955cc39f900300b3ce236756875e.png)

우측에 Table에 저장된 데이터가 보여지게 됩니다. 상단의 Query 버튼을 클릭합니다.

![Machine generated alternative text: WADWindowsEventLogsTable x Add I m port PartitionKey Export Edit Select All Column Options Delete Table Statistics Re fn RowKey 0636779374800000000 1 1bOa88c1-OeOa-48d1-9b73-5e8c16ebOb99 0636779374800000000 0636779374800000000 -OeOa-48dI 1bOa88c1-OeOa-48d1-9b73-5e8c16ebOb99 1bOa88c1 -9b73-5e8c16ebOb99 laaS laaS laaS WindowsVM WindowsVM WindowsVM 0000000004295488675 0000000008590455971 0000000017180390563 ](media/8121e5f6e1c4107950ef78f5c84f2e12.png)

다음과 같이 쿼리 조건을 설정하고, 초록색 실행 버튼을 클릭합니다.

![Machine generated alternative text: And/Or -F Add new clause Advanced Options v Field Eventld Type Int32 Operator Value 4624 ](media/ec885aaf39610cabc1c2431f846aa6b8.png)

결과를 확인하면, Description 속성에서 아래와 같이 접속한 클라이언트의 IP 주소와 계정 등, 다양한 정보들을 확인할 수 있습니다.

![Machine generated alternative text: Eventld - Add new Microsoft Azure Storage Explorer - Edit Entity Int32 Type String String DateTime String String String Int32 Int64 Int32 4624 Value 0636779375400000000 2018-11-16T04:OOB1.107Z Security 1bOa88c1-OeOa-48d1-9b73-5e8c16ebOt x vanced De 8... o... o... 6... tivities Edit Entity Property Name PartitionKey RowKey Timestamp Channel Deploymentld Description Eventld EventTickCount Add Property twork Address: 4624 167.220.233.83 ndows-Security ndows-Security ndows-Security ndows-Security ndows-Security dows-Security ndows-Security ndows-Security ndows-Security ndows-Security 636779375454178819 Cancel Update ](media/1fe61e4d5c7fe71673c41252a71d4bc3.png)

**Linux VM 설정 방법**

Linux VM도 Windows VM과 동일한 방식으로 Azure Portal을 통하여 설정이 가능합니다.
다만, Azure Portal을 통하여 설정을 하는 경우에는 2.\* 버전의 LAD(Linux Azure Diagnostics)가 설정이 이루어집니다.

안타깝게도 LAD 2.\* 버전에서는 로그인에 대한 정보가 상세하게 기록이 되지 않고 있으며, 로그인 성공/실패에 대한 정보를 로깅하기 위해서는 LAD 3.\* 버전의 설치가 필요합니다.
LAD 3.\* 버전은 CLI/PowerShell을 통하여 설정이 가능하며, 해당 방법은 아래의 링크에서 자세하게 다루고 있습니다.

Linux 진단 확장을 사용하여 메트릭 및 로그 모니터링 (<https://docs.microsoft.com/ko-kr/azure/virtual-machines/extensions/diagnostics-linux>)

Azure CLI는 별도로 설치(https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)도 가능하지만, Azure Portal(CloudShell이라고 합니다)에서도 실행할 수 있습니다.
Azure Portal의 CloudShell에는 이미 CLI와 PowerShell이 설치되어 있으므로, 별도의 설치 과정이 필요하지 않습니다.

CloudShell은 Azure Portal 상단의 CloudShell 버튼을 클릭하거나, 

![Machine generated alternative text: jyseong\@microsoftc... MICROSOFT ](media/31df668b778641e7f90d52134590f0ee.png)

별도의 CloudShell 사이트(https://shell.azure.com/)로 접근하여 실행할 수 있습니다.

![Machine generated alternative text: Azure Cloud Shell a https://shell.azure.com/ Azure Cloud Shell Bash Requesting a Cloud Shell. Succeeded. Connecting terminal... Welcome to Azure Cloud Shell Type "az" to use Azure CLI 2.0 Type "help" to learn about Cloud Shell ](media/1b77a358e5160545a23ee49dc1a5b7e5.png)

앞선 링크에 있는 CLI 쿼리를 복사하여 일부 매개변수만 조정하여 실행하면 됩니다. CloudShell에서 실행하는 경우 예제 코드를 모두 실행할 필요는 없으며, 아래의 CLI만 실행하면 됩니다. 수정할 부분은 \<\<수정할 부분\>\>와 같이 하이라이트 하였습니다.

```bash
\# Set your Azure VM diagnostic parameters correctly below
my_resource_group=\<<리소스 그룹 이름\>>
my_linux_vm=\<<설정하려는 VM 이름\>>
my_diagnostic_storage_account=\<<Diagnostics Log를 저장할 Storage account 이름\>>

\# Download the sample Public settings. (You could also use curl or any web browser)

wget <https://raw.githubusercontent.com/Azure/azure-linux-extensions/master/Diagnostic/tests/lad_2_3_compatible_portal_pub_settings.json> -O portal_public_settings.json

\# Build the VM resource ID. Replace storage account name and resource ID in the public settings.

my_vm_resource_id=\$(az vm show -g \$my_resource_group -n \$my_linux_vm --query "id" -o tsv)
sed -i "s\#__DIAGNOSTIC_STORAGE_ACCOUNT__\#\$my_diagnostic_storage_account\#g" portal_public_settings.json
sed -i "s\#__VM_RESOURCE_ID__\#\$my_vm_resource_id\#g" portal_public_settings.json

\# Build the protected settings (storage account SAS token)
my_diagnostic_storage_account_sastoken=\$(az storage account generate-sas--account-name \$my_diagnostic_storage_account --expiry 2037-12-31T23:59:00Z --permissions wlacu --resource-types co --services bt -o tsv)
my_lad_protected_settings="{'storageAccountName': '\$my_diagnostic_storage_account', 'storageAccountSasToken': '\$my_diagnostic_storage_account_sastoken'}"

\# Finallly tell Azure to install and enable the extension
az vm extension set --publisher Microsoft.Azure.Diagnostics --name LinuxDiagnostic --version 3.0 --resource-group \$my_resource_group --vm-name \$my_linux_vm --protected-settings "\${my_lad_protected_settings}" --settings portal_public_settings.json
```

![Machine generated alternative text: i\@Azure:—\$ sed -i "s\# DIAGNOSTIC STORAGE \_ ACCOUNT \#\$my_diagnostic_storage_account\#g" portal_public_settings .json i\@Azure:—\$ sed -i "s\# VM RESOURCE ID \#\$my_vm_resource_id\#g" portal_public_settings .json i\@Azure:—\$ \$my_vm_resource_id ash: [subscriptions/cae76bde-fb86-4335-aef5-33674b746691/resourceGroups/UbuntuLad/providers/Microsoft.Compute/virtua1Machir i\@Azure:—\$ my_diagnostic_storage_account_sastoken=\$(az storage account generate-sas -account-name \$my_diagnostic_storage --services bt -o tsv) es co i\@Azure:—\$ my_lad_protected_settings="{ ' storageAccountName' : '\$my_diagnostic_storage_account' , ' storageAccountSasToken': 'S i\@Azure:—\$ \$my_diagnostic_storage_account_sastoken ash: i\@Azure:—\$ az vm extension set --publisher Microsoft. Azure.Diagnostics - -name LinuxDiagnostic --version 3.0 --resource-grot lad_protected_settings}" - -settings . j son Running . ](media/e0f4d622f8bd47b4b910874db41c7138.png)

설정이 완료된 이후에, ssh를 이용하여 Linux VM으로 접근을 하면 syslog에 해당 정보가 기록이 되고, LAD(Linux Azure Diagnostics)에 의해서 해당 Storage account로 로그가 복사됩니다.

Linux VM의 LAD(Linux Azure Diagnostics) 설정은 WAD(Windows Azure Diagnostics)와는 조금 상이하며, 다음과 같습니다.

![](media/73535af13bc716b47fb290b560a15bcc.png)

로그는 앞서 WAD(Windows Azure Diagnostics) 로그를 확인하는 방법과 같이, Azure Storage Explorer에서 확인하는 방법과 같습니다.
다만, Linux VM의 경우에는 저장되는 Table이 다르며, LinuxSyslogVer2v0라는 Table에 저장됩니다.

또한, 로깅되는 데이터의 기준이 각 Linux Distro별로 조금씩 다르다른 점은 유의해야 합니다.
Ubuntu의 경우에는 로그인 정보는 아래와 같이 Faclity의 유형을 auth로 설정해야만 검색이 가능합니다.

![Machine generated alternative text: Close Query Import (Z And/Or + Add new clause Advanced Options v 2018-11 2018-11 2018-11 1 2018-11 2018-11 2018-11 Export Field Facility FluentdlngestTimestamp 2018-11 Add Edit Type String Select All Column Options Operator auth Msg Removed session 10. Removed session 12. Delete Table Statistics Refresh Facility auth auth auth auth auth auth Host ubuntuV... ubuntuV.. ubuntuV... ubuntuV... ubuntuV... ubuntuV... Ignore syslog syslog syslog syslog syslog syslog PreciseTil Accepted password for labuser from 167.220.233.83 port 58162 ss... New session 16 of user labuser. Accepted password for labuser from 167.220.233.83 port 55316 ss... New session 18 of user labuser. 0000000000000000000 0000000000000000000 ooooooooooooooooooo 0000000000000000000 0000000000000000000 0000000000000000000 ](media/457ae0e5bc57aa0aba1159ac22070408.png)

CentOS의 경우에는 아래와 같이 Facility 유형을 authpriv로 설정해야만 검색이 가능합니다.

![Machine generated alternative text: Close Query Import (Z And/Or + Add new clause Advanced Options v Export Field Facility Add Host Edit Type String Select All Ignore syslog syslog syslog syslog syslog syslog syslog syslog syslog Column Options Operator V uthpriv Msg Delete Table Statistics Refresh ility priv priv priv priv priv priv priv priv priv FluentdlngestTimestamp 2018 2018 2018 2018 2018 2018 2018 -11 -11 sparknamenode... sparknamenode... sparknamenode... sparknamenode... sparknamenode... sparknamenode... sparknamenode... sparknamenode... sparknamenode... pam_unix(sshd:session): session opened for user labuser by (uid=0) pam_unix(sshd:session): session closed for user labuser Accepted keyboard-interactive/pam for labuser from 10.0.0.4 port 50048 ssh2 pam_unix(sshd:session): session opened for user labuser by (uid=0) Accepted password for labuser from 10.0.0.4 port 50049 ssh2 pam_unix(sshd:session): session opened for user labuser by (uid=0) pam_unix(sshd:session): session closed for user labuser pam_unix(sshd:session): session closed for user labuser Accepted keyboard-interactive/pam for labuser from 10.0.0.4 port 50050 ssh2 00000( ](media/6540d8f17221d27a69ba4d40abd89088.png)