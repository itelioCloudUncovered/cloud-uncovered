<#
.SYNOPSIS
   Deaktivierung der Social Bar
 
.DESCRIPTION
   Dieses Skript dient der Deaktivierung der Social Bar
   in SharePoint Online. Tenant URL und ggf. Site URL
   sind entsprechend anzupassen.

.NOTES
  Version:        
  Author:         Raphael Baud
  Creation Date:  2023-07-19
  Purpose/Change: initial creation
#>

#Modul installieren, wenn nicht vorhanden
if (!(Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell
} 

#URL definieren
$AdminSiteURL= "https://tenant-admin.sharepoint.com"

#mit SPO verbinden
Connect-SPOService -Url $AdminSiteURL

#organisationsweit deaktivieren
#zum Aktivieren das Ende auf $false ändern
Set-SPOTenant -SocialBarOnSitePagesDisabled $true


#auf einzelnen Sites deaktivieren
#zum Aktivieren das Ende auf $false ändern
$SiteURL = "https://tenant.sharepoint.com/Sites/Sitename"
Set-SPOSite -Identity $SiteURL -SocialBarOnSitePagesDisabled $true

#Kommentare organisationsweit deaktivieren
#zum Aktivieren das Ende auf $false ändern
#Set-SPOTenant -CommentsOnSitePagesDisabled $true