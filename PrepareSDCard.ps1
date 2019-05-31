$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Write-Host 'This script must be ran as administrator!'
	Read-Host
	Exit
}

'LIST DISK' | diskpart
Write-Host 'Enter the disk number (as shown above) of the SD card you want to prepare. ALL DATA WILL BE LOST!'
$diskNumber = Read-Host
Write-Host "Disk $diskNumber will be repartitioned and formatted.
You can (and should) ignore any popups related to formatting or accessing the SD card.
Everything is already handled by the script.
Press enter to continue..."
Read-Host
"SELECT DISK $diskNumber
CLEAN
CLEAN
CREATE PARTITION PRIMARY SIZE=512
ACTIVE
FORMAT FS=FAT32 QUICK
CREATE PARTITION PRIMARY
EXIT" | diskpart
Write-Host `Done!`
Read-Host