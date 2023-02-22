<#
.SYNOPSIS
   Installation von IP-Druckern
 
.DESCRIPTION
   Dieses Skript dient der Installation von IP-Druckern und zugehöriger Treiber.
   Das Skript ist zur Paketierung mittels IntuneWinAppUtil gedacht.
   Innerhalb des Pakets muss ein Unterordner namens "Drivers" existieren, welcher die
   benötigten Treiber enthält (.inf, .cat und .cab).
   ---
   Installationsbefehl in Intune (Parameter entsprechend befüllen):
   powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File Install-IPPrinter.ps1 -PortIPAddress "" -PrinterName "" -DriverName "" -DriverInfFileName ".inf"
   ---
   Registry-Pfad für Detection Rule:
   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\DRUCKERNAME

 
.EXAMPLE
   Install-IPPrinter.ps1 -PortIPAddress "192.168.1.10" -PrinterName "Drucker 1. OG" -DriverName "HP Universal Printing PCL 6" -DriverInfFileName "hpcu255u.inf"
 
.PARAMETER PortIPAddress
   Die IP-Adresse des Druckers.

.PARAMETER PrinterName
   Der Name, unter welchem der Drucker eingebunden werden soll.

.PARAMETER DriverName
   Der exakte Name des Treibers. Dieser ist aus der .inf-Datei ersichtlich (im Texteditor öffnen).

.PARAMETER DriverInfFileName
   Der Name der .inf-Datei inklusive Dateiendung, z.B. "hpcu255u.inf".

.NOTES
  Version:        1.0
  Author:         Raphael Baud
  Creation Date:  2023-02-22
  Purpose/Change: Creation
#>

#################
#---Parameter---#
#################
Param(
    [Parameter(Mandatory=$True)]
    [string]$PortIPAddress,

    [Parameter(Mandatory=$True)]
    [string]$PrinterName,

    [Parameter(Mandatory=$True)]
    [string]$DriverName,

    [Parameter(Mandatory=$True)]
    [string]$DriverInfFileName
)

#################
#---Execution---#
#################

#Pfad definieren
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

#PortName definieren
$PortName = "IP_$PortIPAddress"

#Treiber stagen
pnputil /add-driver "$PSScriptRoot\Drivers\$DriverInfFileName" /install

#Treiber installieren
Add-PrinterDriver -Name $DriverName

#Druckerport installieren, wenn noch nicht vorhanden
if(-not (Get-PrinterPort -Name $PortName -ErrorAction SilentlyContinue)) {

    Add-PrinterPort -Name $PortName -PrinterHostAddress $PortIPAddress

}

#Drucker verbinden, wenn Treiber erfolgreich installiert wurde
if((Get-PrinterDriver -Name $DriverName -ErrorAction SilentlyContinue)) {

    Add-Printer -Name $PrinterName -PortName $PortName -DriverName $DriverName

} else {

    Write-Warning "Treiber nicht installiert"
    exit 1

}

#nach der Installation etwas abwarten, um das Detection Script zu verzögern
Start-Sleep -Seconds 180
