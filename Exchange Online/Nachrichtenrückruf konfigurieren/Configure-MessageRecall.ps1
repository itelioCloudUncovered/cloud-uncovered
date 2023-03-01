<#
.SYNOPSIS
   (De-)Aktivierung des neuen Cloud-Based Message Recall in Exchange Online
 
.DESCRIPTION
   Die Befehle in diesem Skript sind einzeln auszuführen, um den jeweils 
   gewünschten Effekt zu erzielen.
   Wird das Skript als Ganzes ausgeführt, wird der Message Recall zuerst deaktiviert
   und anschließend wieder aktiviert.

.NOTES
  Version:        
  Author:         Raphael Baud
  Creation Date:  2023-03-01
  Purpose/Change: Initial Creation
#>

#################
#---Execution---#
#################

#Modul installieren, wenn nicht bereits installiert
if (!(Get-Module -ListAvailable -Name ExchangePowerShell)) {
    Install-Module ExchangePowerShell
} 

#mit EXO verbinden
Connect-ExchangeOnline

#aktuelle Konfiguration auslesen
Write-Host "MessageRecallEnabled: $((Get-OrganizationConfig).MessageRecallEnabled)"
Write-Host "RecallReadMessagesEnabled: $((Get-OrganizationConfig).RecallReadMessagesEnabled)"

#--Aktivierung--#

#Message Recall allgemein deaktivieren
Set-OrganizationConfig -MessageRecallEnabled $false

#Message Recall für gelesene Mails deaktivieren
Set-OrganizationConfig -RecallReadMessagesEnabled $false


#--Deaktivierung--#

#Message Recall allgemein aktivieren
Set-OrganizationConfig -MessageRecallEnabled $true

#Message Recall für gelesene Mails aktivieren
Set-OrganizationConfig -RecallReadMessagesEnabled $true