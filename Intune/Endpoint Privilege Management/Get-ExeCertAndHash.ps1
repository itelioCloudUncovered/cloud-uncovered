<#
.SYNOPSIS
   Liest Publisherzertifikat und File Hash einer .exe-Datei aus
 
.DESCRIPTION
   Dieses Skript dient zum Auslesen des Publisherzertifikats und File Hash
   einer .exe-Datei. Beides wird für die Konfiguration von Elevation Rules
   Policies in Endpoint Privilege Management genutzt.
   $ExePath und $CertOutPath sind entsprechend zu befüllen.

.NOTES
  Version:        
  Author:         Raphael Baud
  Creation Date:  2023-05-03
  Purpose/Change: initial creation
#>

#################
#---Execution---#
#################

$ExePath = "C:\Program Files\beispiel\beispiel.exe"
$CertOutPath = "C:\temp\Certificate.cer"

Get-AuthenticodeSignature $ExePath | Select-Object -ExpandProperty SignerCertificate | Export-Certificate -Type CERT -FilePath $CertOutPath

Get-FileHash $ExePath | select-object Hash