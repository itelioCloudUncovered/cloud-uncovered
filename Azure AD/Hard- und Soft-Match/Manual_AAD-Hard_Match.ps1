<#
.SYNOPSIS
   Azure AD Connect manuellen Hard-Match ausführen
 
.DESCRIPTION
   Die Befehle in diesem Skript sind idealerweise einzeln auszuführen.
   Die Anmerkungen der einzelnen Schritte sind zu beachten.
.NOTES
  Version:        1.0
  Author:         Thomas Thaler
  Creation Date:  2023-04-04
  Purpose/Change: Creation
#>

Install-Module MSOnline
Import-Module MSOnline
Import-Module ActiveDirectory

#Mit Global Admin verbunden
Connect-MsolService

#Variablen ausfüllen
$ADUser = "<SAMAccountName>" 
$AzureADUser = "<UPN>"

$guid =(Get-ADUser $ADUser).Objectguid

$immutableID=[system.convert]::ToBase64String($guid.tobytearray())

Set-MsolUser -UserPrincipalName "$AzureADUser" -ImmutableId $immutableID
