<#
.SYNOPSIS
   Kennwortablauf eines Users deaktivieren
 
.DESCRIPTION
   Dieses Skript deaktiviert den Ablauf des Kennworts eines Users in Azure AD.
   Das benötigte Modul Microsoft.Graph wird installiert, falls es noch nicht vorhanden ist.

.NOTES
  Version:        
  Author:         Raphael Baud
  Creation Date:  2023-05-17
  Purpose/Change: 
#>

#UPN des Users
$UserPrincipalName = "patrick.stern@itestlio.com"

#Modul installieren, wenn nicht vorhanden
if (!(Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module -Name Microsoft.Graph
}

#mit Graph verbinden
Connect-MgGraph


#aktuelle Kennwortrichtlinie prüfen
Get-MgUser -UserId $UserPrincipalName -Property UserPrincipalName, PasswordPolicies

#Kennwortrichtlinie setzen, sodass das Kennwort nie abläuft
Update-MgUser -UserId $UserPrincipalName -PasswordPolicies DisablePasswordExpiration -PassThru

#Kennwortrichtlinie entfernen, sodass das Kennwort wieder abläuft
#Update-MgUser -UserId $UserPrincipalName -PasswordPolicies None -PassThru