<#
.SYNOPSIS
   Azure AD Password Protection DC Agent Configuration
 
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

#Pfad zur AzureADPasswordProtectionDCAgentSetup.msi
#Download im Microsoft Download Center: https://www.microsoft.com/en-us/download/details.aspx?id=57071
$InstallerPath = "C:\temp\install"

#UPN des Global- oder Security-Admins
$AdminUPN = "admin@tenant.onmicrosoft.com"



#DC-Agent installieren
cd $InstallerPath
msiexec.exe /i AzureADPasswordProtectionDCAgentSetup.msi /quiet /qn /norestart
#nach der Installation muss der DC neugestartet werden. /norestart aus dem Befehl entfernen, um den Neustart automatisch durchzuführen

#nach Neustart:
#Modul importieren
Import-Module AzureADPasswordProtection 

#Status des Agenten prüfen
#PasswordPolicyDateUTC sollte aktuellen Zeitstempel für die heruntergeladene Policy zeigen
Get-AzureADPasswordProtectionDCAgent


#Summary Report für alle DCs generieren
Get-AzureADPasswordprotectionSummaryReport 