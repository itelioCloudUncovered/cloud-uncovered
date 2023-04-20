<#
.SYNOPSIS
   Teams-Erstellung verbieten
 
.DESCRIPTION
   Dieses Skript deaktiviert die Teams-Erstellung durch reguläre User.
   Die Schaltfläche "Team erstellen" wird dadurch nicht mehr im Teams-Client angezeigt.
   In die Variable $GroupName ist der Name einer Sicherheitsgruppe einzutragen.
   Mitglieder dieser Gruppe dürfen weiterhin Teams erstellen.
 
.NOTES
  Version:        
  Author:         Raphael Baud
  Creation Date:  2023-04-20
  Purpose/Change: initial creation
#>

#################
#---Execution---#
#################

#GroupName ist der Name der Sicherheitsgruppe, deren Mitglieder weiterhin Teams erstellen dürfen
$GroupName = "G_User_TeamsCreation"
$AllowGroupCreation = "False"


#Modul installieren, wenn noch nicht vorhanden
#Wichtig: ggf. muss zuerst das Modul "AzureAD" deinstalliert werden
#Uninstall-Module AzureAD
if (!(Get-Module -ListAvailable -Name AzureADPreview)) {
    Install-Module -Name AzureADPreview
} 


#Mit Azure AD verbinden
Connect-AzureAD



$GroupSettingsId = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id

#Settings erstellen, wenn noch nicht vorhanden
if(!$GroupSettingsId) {

    $Template = Get-AzureADDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}
    $NewGroupSettings = $Template.CreateDirectorySetting()
    New-AzureADDirectorySetting -DirectorySetting $NewGroupSettings
    $GroupSettingsId = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id

}
$NewGroupSettings = Get-AzureADDirectorySetting -Id $GroupSettingsId

#Team-Erstellung erlauben/verbieten
$NewGroupSettings["EnableGroupCreation"] = $AllowGroupCreation

#Team-Erstellung durch Sicherheitsgruppe erlauben
$NewGroupSettings["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString $GroupName).objectid

#Einstellungen anwenden
Set-AzureADDirectorySetting -Id $GroupSettingsId -DirectorySetting $NewGroupSettings

(Get-AzureADDirectorySetting -Id $GroupSettingsId).Values