<#
.SYNOPSIS
   Konfiguration einer SharePoint Online Assets Library
 
.DESCRIPTION
   Dieses Skript dient der Konfiguration einer SPO-Dokumentenbibliothek als organisationsweite
   Assets Library. Office-Vorlagen innerhalb der Bibliothek werden den Usern in Office-Anwendungen
   wie Word, Excel oder PowerPoint beim Erstellen neuer Dokumente angezeigt.

.NOTES
  Version:        
  Author:         Raphael Baud
  Creation Date:  2023-03-08
  Purpose/Change: initial creation
#>


#URLs definieren
$AdminSiteURL= "https://tenant-admin.sharepoint.com"
$SiteURL = "https://tenant.sharepoint.com/sites/SiteName"
$LibraryURL = "https://tenant.sharepoint.com/sites/SiteName/LibraryName"

#Modul installieren, wenn nicht vorhanden
if (!(Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell
} 
 
#mit SPO verbinden
Connect-SPOService -Url $AdminSiteURL
 
#Assets Library definieren
Add-SPOOrgAssetsLibrary -LibraryUrl $LibraryURL -OrgAssetType OfficeTemplateLibrary