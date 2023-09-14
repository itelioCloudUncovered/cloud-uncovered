<#
.SYNOPSIS
   Code-Snippet zum Verbinden mit der Graph-Powershell via Zertifikat
 
.DESCRIPTION
   Die Inhalte hier können in ein bestehendes Script als Verbindungs-Block eingefügt werden. 
   Darüber wird eine verbindung via Zertifikatsauthentifizierung mit der Microsoft.Graph Powershell
   herstellt.
   Voraussetzung ist eine Entra ID App-Registrierung.

.NOTES
  Version:        
  Author:         Thomas Thaler
  Creation Date:  2023-09-14
  Purpose/Change: Initial Creation
#>


$TenantId = "<TenantId>"    #<TenantId> durch des Zieltenants ersetzen

$ClientId = "<ClientId>"    #<ClientId> durch App- bzw. Client-Id der registrierten App ersetzen

#Wahlweise Thumbprint oder Subject verwenden.
$CertThumbprint = "<Thumbprint>"
$CertSubject = "<Subject>"

#Graph Powershell Modul installieren, falls es nicht installiert ist
if (!(Get-Module -ListAvailable -Name Microsoft.Graph)) {
        Write-Host "Microsoft.Graph Powershell-Modul wird installiert"
        Install-Module MgGraph -Scope CurrentUser
    } 


#Zertifikat liegt im Zertifikatsspeicher des angemeldeten Benutzers
Connect-MGGraph -ClientId $ClientId -TenantId $TenantId -CertificateThumbprint $CertThumbprint


#Alternative: Zertifikat liegt im Computer-Speicher
$Cert = Get-ChildItem Cert:\LocalMachine\My\$CertThumbprint
Connect-MgGraph -ClientId "$clientid" -TenantId "$tenantid" -Certificate $Cert
