<#
.SYNOPSIS
   Erkennung von RunAs-Accounts in Azure Runbooks.
 
.DESCRIPTION
   Dieses Skript erkennt Runbooks, welche RunAs-Accounts zur Authentifizierung
   nutzen, in einer Azure Subscription. Die Skripte werden (temporär) heruntergeladen
   und entsprechend analysiert.

.NOTES
  Version:        
  Author:         Raphael Baud
                  Tobias Remmerbach
  Creation Date:  2023-07-03
  Purpose/Change: Initial Creation
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$OutputFolder = "C:\itelio-AUM-Temp",

    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId
)

#benötigte Module installieren
if(!(Get-InstalledModule -Name Az.Accounts)) {
    Install-Module Az.Accounts
}
if(!(Get-InstalledModule -Name Az.Resources)) {
    Install-Module Az.Resources
}

#mit Azure verbinden
Connect-AzAccount

#Arrays vorbereiten
$RGs = @()
$Accounts = @()
$Runbooks = @()

#alle RGs und Automation Accounts der Subscription auslesen
$RGs = Get-AzResourceGroup
foreach($RG in $RGs) {
    $Accounts +=@(Get-AzAutomationAccount -ResourceGroupName $RG.ResourceGroupName)
}

#alle  Runbooks in allen Automation Accounts auslesen
foreach($Account in $Accounts) {
    $Runbooks +=@(Get-AzAutomationRunbook -ResourceGroupName $Account.ResourceGroupName -AutomationAccountName $Account.AutomationAccountName)
}

#wenn Runbooks vorhanden sind, weitermachen, sonst Abbruch am Ende des Skripts
if($Runbooks) {
    
    #Prüfen, ob der Output Folder vorhanden ist, sonst erstellen
    if(!(Test-Path $OutputFolder)){
        New-Item -ItemType Directory -Path $OutputFolder > $null
    }
    
    #Output Folder nach Bestätigung leeren, sonst Skript beenden
    $OutputFolderContent = Get-ChildItem -Path $OutputFolder
    if($OutputFolderContent) {
        $Confirmation = Read-Host "Der gewählte Output Folder ($OutputFolder) ist nicht leer. Soll der Ordner geleert werden? (Y/N)"
        if ($Confirmation -eq 'y') {
            foreach($Item in $OutputFolderContent) {
                Remove-Item -Path "$OutputFolder\$Item" -Force
            }
        } else {
            Write-Host "Ausführung wird abgebrochen. Bitte leeren Sie den Output Folder ($OutputFolder)."
            return 0
        }
    }

    #Runbooks in den Output Folder herunterladen
    foreach($Runbook in $Runbooks) {
        Export-AzAutomationRunbook -Name $Runbook.Name -ResourceGroupName $Runbook.ResourceGroupName -AutomationAccountName $Runbook.AutomationAccountName -OutputFolder $OutputFolder > $null
    }


    Write-Host "Skripte werden temporär heruntergeladen." -ForegroundColor DarkGreen
    Write-Host "Inhalt der Skripte wird geprüft..." -ForegroundColor DarkGreen

    #einzelne Skripte prüfen
    $ScriptFiles = Get-ChildItem -Path $OutputFolder
    $RunAsFound = $false
    foreach($ScriptFile in $ScriptFiles) {
        #Inhalt der .ps1-Datei auf AzureRunAsConnection prüfen
        $ScriptContent = Get-Content -Path "$OutputFolder\$ScriptFile"
        if($ScriptContent -match 'Get-AutomationConnection -Name "AzureRunAsConnection"') {
            $RunAsFound = $true
        }
    }

    if($RunAsFound){
        Write-Host "--------------------------------------------------" -ForegroundColor Yellow
        Write-Host "Nutzung eines Run As Accounts festgestellt!" -ForegroundColor Red
        Write-Host "--------------------------------------------------" -ForegroundColor Yellow
    }

    #Output Folder leeren
    $OutputFolderContent = Get-ChildItem -Path $OutputFolder
    Remove-Item -Path "$OutputFolder" -Force -Recurse
    Write-Host "Temporäre Dateien entfernt." -ForegroundColor DarkGreen

} else {
    #Abbruch, wenn keine Runbooks in der Subscription gefunden wurden
    Write-Host "Es wurden keine betroffenen Runbooks in der Subscription gefunden." -ForegroundColor Green

}