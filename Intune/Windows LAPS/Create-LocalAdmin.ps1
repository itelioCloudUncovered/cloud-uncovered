<#
.SYNOPSIS
   Erstellung eines lokalen Administrators
 
.DESCRIPTION
   Dieses Skript erstellt einen lokalen Administrator.
   Das Skript ist gedacht für die Verteilung über Intune, sodass ein
   lokaler Administrator für die Konfiguration von Windows LAPS
   vorhanden ist.
   Der Name des Kontos ist im Parameter entsprechend zu befüllen.
   Das initiale Kennwort wird bei der Ausführung des Skripts zufällig
   generiert.

.NOTES
  Version:        1.0
  Author:         Raphael Baud
  Creation Date:  2023-05-24
  Purpose/Change: initial creation
#>

#Name des Kontos
$LocalAdminUsername = "lapsadmin"

#zufälliges Kennwort generieren
$Password = ConvertTo-SecureString -String (-join ((33..126) | Get-Random -Count 32 | % {[char]$_})) -AsPlainText -Force

#Benutzer erstellen
New-LocalUser -Name $LocalAdminUsername -Password $Password -Description "Windows LAPS Admin Account"

#Benutzer zu lokalen Admins hinzufügen
Add-LocalGroupMember -SID S-1-5-32-544 -Member $LocalAdminUsername