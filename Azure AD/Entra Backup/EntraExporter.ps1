<#
.SYNOPSIS
   EntraExporter Script ausführen
 
.DESCRIPTION
   Die Inhalte sind lediglich eine Zusammenfassung der Schritte um einen Export des Entra ID auszuführen
   EntraExporter wird hier dokumentiert und entwickelt: https://github.com/microsoft/EntraExporter

.NOTES
  Version:        
  Author:         Thomas Thaler
  Creation Date:  2023-08-30
  Purpose/Change: 
#>

# Modul installieren
Install-Module EntraExporter

# Export über Powershell 7 ausführen
Connect-EntraExporter
Export-Entra -Path "C:\Temp\EntraExport\"


# Gültige Werte für -Type
(Get-Command Export-Entra | Select-Object -Expand Parameters)['Type'].Attributes.ValidValues
