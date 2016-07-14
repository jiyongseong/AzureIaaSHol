#
# IISDSC.ps1
#
#
Configuration Main
{

Import-DscResource -ModuleName PSDesiredStateConfiguration

Node ("localhost")
  {
  	#Install the IIS Role
	WindowsFeature IIS
	{
		Ensure = "Present"
		Name = "Web-Server"
	}

	#Install ASP.NET 4.5
	WindowsFeature ASP45
	{
		Ensure = "Present"
		Name = "Web-Asp-Net45"
	}

	#Install ASP.NET 3.5
	WindowsFeature ASP35
	{
		Ensure = "Present"
		Name = "Web-Asp-Net"
	}

	#Install NET Extensibility 35
	WindowsFeature NetExt35
	{
		Ensure = "Present"
		Name = "Web-Net-Ext"
	}
		
	#Install NET Extensibility 45
	WindowsFeature NetExt45
	{
		Ensure = "Present"
		Name = "Web-Net-Ext45"
	}

	#Install ISAPI Filters
	WindowsFeature ISAPI_Filters
	{
		Ensure = "Present"
		Name = "Web-ISAPI-Filter"
	}

	#Install ISAPI Extensions
	WindowsFeature WebISAPI_EXT
	{
		Ensure = "Present"
		Name = "Web-ISAPI-Ext"
	}

	#Install Default Document
	WindowsFeature DefaultDocument
	{
		Ensure = "Present"
		Name = "Web-Default-Doc"
	}

	#Install Static Content
	WindowsFeature StaticContent
	{
		Ensure = "Present"
		Name = "Web-Static-Content"
	}

	#Install Dynamic Content Compression
	WindowsFeature DynamicContentCompression
	{
		Ensure = "Present"
		Name = "Web-Dyn-Compression"
	}
		
	#Install Static Content Compression
	WindowsFeature StaticContentCompression
	{
		Ensure = "Present"
		Name = "Web-Stat-Compression"
	}

	#Install Request Filtering
	WindowsFeature RequestFiltering
	{
		Ensure = "Present"
		Name = "Web-Filtering"
	}

	WindowsFeature WebServerManagementConsole
	{
		Name = "Web-Mgmt-Console"
		Ensure = "Present"
	}
	<# This commented section represents an example configuration that can be updated as required.
    WindowsFeature WebManagementConsole



    WindowsFeature HTTPRedirection
    {
      Name = "Web-Http-Redirect"
      Ensure = "Present"
    }
    WindowsFeature CustomLogging
    {
      Name = "Web-Custom-Logging"
      Ensure = "Present"
    }
    WindowsFeature LogginTools
    {
      Name = "Web-Log-Libraries"
      Ensure = "Present"
    }
    WindowsFeature RequestMonitor
    {
      Name = "Web-Request-Monitor"
      Ensure = "Present"
    }
    WindowsFeature Tracing
    {
      Name = "Web-Http-Tracing"
      Ensure = "Present"
    }
    WindowsFeature BasicAuthentication
    {
      Name = "Web-Basic-Auth"
      Ensure = "Present"
    }
    WindowsFeature WindowsAuthentication
    {
      Name = "Web-Windows-Auth"
      Ensure = "Present"
    }
    WindowsFeature ApplicationInitialization
    {
      Name = "Web-AppInit"
      Ensure = "Present"
    }
    Script DownloadWebDeploy
    {
        TestScript = {
            Test-Path "C:\WindowsAzure\WebDeploy_amd64_en-US.msi"
        }
        SetScript ={
            $source = "http://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi"
            $dest = "C:\WindowsAzure\WebDeploy_amd64_en-US.msi"
            Invoke-WebRequest $source -OutFile $dest
        }
        GetScript = {@{Result = "DownloadWebDeploy"}}
        DependsOn = "[WindowsFeature]WebServerRole"
    }
    Package InstallWebDeploy
    {
        Ensure = "Present"  
        Path  = "C:\WindowsAzure\WebDeploy_amd64_en-US.msi"
        Name = "Microsoft Web Deploy 3.6"
        ProductId = "{ED4CC1E5-043E-4157-8452-B5E533FE2BA1}"
        Arguments = "ADDLOCAL=ALL"
        DependsOn = "[Script]DownloadWebDeploy"
    }
    Service StartWebDeploy
    {                    
        Name = "WMSVC"
        StartupType = "Automatic"
        State = "Running"
        DependsOn = "[Package]InstallWebDeploy"
    } #>
  }
}