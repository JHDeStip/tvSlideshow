$ErrorActionPreference = 'Stop'

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Write-Host 'This script must be ran as administrator!'
	Read-Host
	Exit
}

$shareUserName = 'TVPI'

Write-Host '----(RE)CREATING USER FOR NETWORK SHARE'
if (Get-LocalUser | where { $_.Name -eq $shareUserName }) {
	Remove-LocalUser $shareUserName
}
New-LocalUser $shareUserName -UserMayNotChangePassword -Password (ConvertTo-SecureString $shareUserName -Force -AsPlainText)

$fullUserName = (Get-WMIObject -class Win32_ComputerSystem | select UserName).UserName
$fullUserNameParts = $fullUserName.Split('\')
$userName = $fullUserNameParts | Select-Object -Last 1
$domain = $fullUserName.SubString(0, $fullUserName.Length - $userName.Length - 1)
$userDirectory = (Get-WMIObject -class Win32_UserProfile | where { $_.PScomputerName -eq $domain -and $_.LocalPath.EndsWith("\$userName") }).LocalPath
$desktop = "$userDirectory\Desktop"
$shareDirectory = "$desktop\Presentatie TV"

Write-Host '----ENSURING DIRECTORY FOR NETWORK SHARE EXISTS'
if (-Not (Test-Path $shareDirectory)) {
	New-Item $shareDirectory -ItemType Directory
}

Write-Host '----SETTING PERMISSIONS ON SHARED DIRECTORY'
$acl = Get-Acl $shareDirectory
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($shareUserName, 'Read', 'ObjectInherit,ContainerInherit', 'NoPropagateInherit', 'Allow')
$acl.SetAccessRule($rule)
$owner = New-Object System.Security.Principal.NTAccount($userName)
$acl.SetOwner($owner)
Set-Acl $shareDirectory $acl

Write-Host '----(RE)CEATING NETWORK SHARE'
if (Get-SmbShare | where { $_.Name -eq $shareUserName }) {
	Remove-SmbShare $shareUserName -Force
}
New-SmbShare $shareUserName -Path $shareDirectory -ReadAccess $shareUserName

Write-Host '----DONE!'
Read-Host