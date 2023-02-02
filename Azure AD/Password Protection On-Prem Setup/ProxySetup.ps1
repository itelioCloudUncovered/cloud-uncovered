<#
.SYNOPSIS
   Azure AD Password Protection Proxy Configuration
 
.DESCRIPTION
   Die Befehle in diesem Skript sind idealerweise einzeln auszuführen.
   Die Anmerkungen der einzelnen Schritte sind zu beachten.

.NOTES
  Version:        1.0
  Author:         Raphael Baud
  Creation Date:  2023-02-02
  Purpose/Change: Creation
#>

#################
#---Execution---#
#################

#Pfad zur AzureADPasswordProtectionProxySetup.exe
#Download im Microsoft Download Center: https://www.microsoft.com/en-us/download/details.aspx?id=57071
$InstallerPath = "C:\temp\install"

#UPN des Global- oder Security-Admins
$AdminUPN = "admin@tenant.onmicrosoft.com"



#Proxy installieren
cd $InstallerPath
.\AzureADPasswordProtectionProxySetup.exe /quiet


#Modul importieren
Import-Module AzureADPasswordProtection 


#Dienststatus prüfen 
#sollte "Running" anzeigen
Get-Service AzureADPasswordProtectionProxy | fl 



#Proxy registrieren – Global oder Security Admin benötigt, unterstützt MFA 
#auf jedem Proxy ausführen 
Register-AzureADPasswordProtectionProxy –AccountUpn $AdminUPN

#sollte es fehlschlagen, z.B. wegen der IE Security Config, hinten –AuthenticateUsingDeviceCode anhängen und Device Auth über den Browser durchführen 
Register-AzureADPasswordProtectionProxy –AccountUpn $AdminUPN -AuthenticateUsingDeviceCode

#sollte die Registrierung fehlschlagen, kurz abwarten und nochmal versuchen 



#Registrierung und Verbindung zu Azure testen 
#sollte "Passed" für TLS, Proxy und Azure anzeigen 
Test-AzureADPasswordProtectionProxyHealth -TestAll 



#AD-Forest registrieren – Global oder Security Admin benötigt, unterstützt MFA
#der am Proxy-Server angemeldete Benutzer benötigt außerdem Enterprise Admin im lokalen AD  
#nur einmal pro Forest auf einem beliebigen Proxy ausführen 
Register-AzureADPasswordProtectionForest –AccountUpn $AdminUPN

#sollte es fehlschlagen, z.B. wegen der IE Security Config, hinten –AuthenticateUsingDeviceCode anhängen und Device Auth über den Browser durchführen
Register-AzureADPasswordProtectionForest –AccountUpn $AdminUPN -AuthenticateUsingDeviceCode