<#
.SYNOPSIS
   Deaktivierung der Self-Service-Lizenzbuchung durch User
 
.DESCRIPTION
   Dieses Skript deaktiviert die Möglichkeit, dass User ohne Adminrechte selbstständig
   Lizenzen buchen können. Im Standard können User Zahlungsmethoden hinterlegen,
   um Lizenzen für verschiedene Dienste zu buchen. Außerdem bieten bestimmte Dienste
   normalerweise die Möglichkeit, Trials ohne hinterlegte Zahlungsmethoden zu starten.
   Es empfiehlt sich, diese Möglichkeiten zu deaktivieren, um sicherzustellen, dass
   Benutzer nicht selbstständig Dienste testen/nutzen.
   Die (Trial-)Buchung durch Admins über das Microsoft 365 Admin Center ist weiterhin
   möglich.

.NOTES
  Version:        
  Author:         Raphael Baud
  Creation Date:  2023-03-15
  Purpose/Change: initial creation
#>

#Modul installieren, wenn nicht vorhanden
if (!(Get-Module -ListAvailable -Name MSCommerce)) {
    Install-Module -Name MSCommerce
} 
 
#mit MSCommerce verbinden
Connect-MSCommerce
 
#verfügbare Produkte auslesen
$Products = Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase

#Self-Service-Buchung für jedes Produkt deaktivieren
foreach($Product in $Products) {
    #nur durchführen, wenn $Product auch ein "echtes" Produkt mit ProductID ist
    if($Product.ProductID) {
        Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -ProductId $Product.ProductID -Value "Disabled" 
    }
}