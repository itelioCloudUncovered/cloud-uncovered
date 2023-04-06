<#
.SYNOPSIS
   Azure AD Connect Soft Match deaktivieren
 
.DESCRIPTION
   Die Befehle in diesem Skript sind idealerweise einzeln auszuführen.
   Die Anmerkungen der einzelnen Schritte sind zu beachten.
.NOTES
  Version:        1.0
  Author:         Thomas Thaler
  Creation Date:  2023-04-04
  Purpose/Change: Creation
#>

#Azure AD Modul installieren
Install-Module MSOnline
Import-Module MSOnine

#Mit globalem Admin-Account verbinden
Connect-MSOLService

Set-MsolDirSyncFeature -Feature BlockSoftMatch -Enable $true

#Reaktivieren Soft-Matching bei Bedarf
# Set-MsolDirSyncFeature -Feature BlockSoftMatch -Enable $false
