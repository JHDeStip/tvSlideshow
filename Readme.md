# TV slideshow
These scripts create a shared folder on a Windows computer and set up a Raspberry Pi to automatically play a *.odp* slideshow full screen when started using LibreOffice.

## Shared folder installation
The shared folder will be put on the desktop of the user that runs the script and will be named *Presentatie TV*. The *.odp* file in this folder with the latest modification date will be automatically shown by the Raspberry Pi. 
* Copy the script *CreateShare.ps1* to the computer you want to create the share on.
* Open a PowerShell prompt as administrator.
* Ensure running scripts is enabled. If this is not yet the case or you are not sure run *Set-ExecutionPolicy RemoteSigned* and answer *Y*.
* Run the *CreateShare.ps1* script. If it runs without errors the shared folder is created with the correct permissions.

## Raspberry Pi installation
* Download the latest version of Alpine Linux for the aarch64 architecture from [here](https://alpinelinux.org/downloads/).
* Insert the SD card for the Pi and run the *PrepareSDCard.ps1* script.
* Extract the Alpine Linux files to the SD card.
* Create a folder *fonts* on the SD card and copy the contents of the *C:\Windows\Fonts* folder (preferably from a clean Windows installation) to it. Use the command line to copy the files, copying through the UI does not seem to work well for files inside *C:\Windows\Fonts*.
* Copy the scripts *setup.sh*, *setup2.sh* and *startShow.sh* to the SD card. Ensure these files have Linux line endings, otherwise it will not work.
* Insert the SD card into the Pi and start it with HDMI and ethernet (with internet access) connected.
* Login with user *root* and no password.
* Run the script */media/mmcblk0p1/setup.sh* and answer the questions.
* When the script finishes the Pi will reboot. It will sit on the log in prompt for a while but it's actually still setting things up in the background so don't do anything to it! After it finishes it will reboot again. If everything went well the slideshow should start playing.

## Notes
* The setup script will ask for the IP address of the computer where the shared folder is on. This means the computer must have a fixed IP address and it should be reachable by the Pi over the network.
* All file systems of the Pi are mounted as read only and use an overlay file system that writes any changes to RAM. This means there is no risk that the SD card gets corrupted and you can safely turn off the Pi at any time without gracefully shutting it down. Everytime the Pi starts it will be completely fresh.
* The Pi will automatically shut down at 3 A.M. and this will also cause the TV to go into standby because the HDMI output stops. It's not a big deal if you forget to turn it off when you leave (although this is still preferred).
* The Pi draws power from the TV, so it automatically starts and stops when the TV is turned on or off respectively.
* The Pi does not automatically install updates. If you need a newer version of Alpine Linux, LibreOffice or any other component you can reinstall it from scratch. When the Pi is installed it will always take the latest version of everything.
* The installation scripts enable SSH login for user *root* with the password you entered when running the setup script. If you configure you router to give a fixed IP address to the Pi then you can always access it over SSH, for example for diagnostics.
* The Pi needs to be connected to the network over ethernet as only the wired network interface is configured.