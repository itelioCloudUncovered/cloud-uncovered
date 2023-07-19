<#
.SYNOPSIS
   Erstellung eines eigenen Themes in SharePoint Online
 
.DESCRIPTION
   Dieses Skript dient der Erstellung eines eigenen Farbschemas
   in SharePoint Online. Tenant URL, Farbcodes und Themename sind
   im Skript entsprechend anzupassen.

.NOTES
  Version:        
  Author:         Raphael Baud
  Creation Date:  2023-07-19
  Purpose/Change: initial creation
#>


#URL definieren
$AdminSiteURL= "https://tenant-admin.sharepoint.com"

#Modul installieren, wenn nicht vorhanden
if (!(Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell
} 

#mit SPO verbinden
Connect-SPOService -Url $AdminSiteURL

#Theme definieren - hier Farbcodes einfügen
$ThemePalette = @{
    "themePrimary" = "#a821de";
    "themeLighterAlt" = "#070109";
    "themeLighter" = "#1b0523";
    "themeLight" = "#330a43";
    "themeTertiary" = "#651485";
    "themeSecondary" = "#941dc3";
    "themeDarkAlt" = "#b035e1";
    "themeDark" = "#bc51e6";
    "themeDarker" = "#cd7cec";
    "neutralLighterAlt" = "#f8f8f8";
    "neutralLighter" = "#f4f4f4";
    "neutralLight" = "#eaeaea";
    "neutralQuaternaryAlt" = "#dadada";
    "neutralQuaternary" = "#d0d0d0";
    "neutralTertiaryAlt" = "#c8c8c8";
    "neutralTertiary" = "#3a1f59";
    "neutralSecondary" = "#200c37";
    "neutralPrimaryAlt" = "#1b092f";
    "neutralPrimary" = "#000000";
    "neutralDark" = "#0b0215";
    "black" = "#05000b";
    "white" = "#ffffff";
}

#Theme hinzufügen - hier Name einfügen
Add-SPOTheme -Identity "Mein lilafarbenes Theme" -Palette $ThemePalette -IsInverted $false

#Theme entfernen
#Remove-SPOTheme -Identity "Mein lilafarbenes Theme"