#Name und Exportpfad angeben
$certname = "Name des Zertifikats"
$ExportPath = "$env:USERPROFILE\Desktop\$certname.cer"

#Zertifikat erstellen
$cert = New-SelfSignedCertificate -Subject "CN=$certname" -CertStoreLocation "Cert:\CurrentUser\My" `
-KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256

#Zertifikat als Datei exportieren
Export-Certificate -Cert $cert -FilePath "$ExportPath"

#Subject und Thumbprint auslesen
$cert.Subject
$cert.Thumbprint