ahk-scripts
===========

Different AHK scripts (also included in AHK Command Picker) 

What's in here
==============

AHK Command Picker - http://ahkcommandpicker.codeplex.com/
It's pretty much unmodified so i strongly recommend you to read doc @ http://ahkcommandpicker.codeplex.com/documentation to get you started on what AHK Command Picker is and how to use it.


Besides AHK CmdPicker's general shortcuts/hotkeys i have included my own Functions and shortcuts which are suited to me so if you want to use everything you will have to adjust them for your needs.

How To
======
Run AHKCommandPicker.ahk and activate it by pressing Caps-Lock (you are really not using it)

In \Commands folder all files with underscore are my additions you can check their content for more detail.

For some functions like uTorrent and PSExec to work you need to create another ahk file one folder above the current folder (..\Vars.ahk)

Example Vars.ahk:
uTorrentIP = 192.168.1.1
uTorrentPort = 8080
uTorUser = admin
uTorPass = someutorrentpass
;=======Sysinternals
SysInternals = D:\Install\SysinternalsSuite
RemoteComputer = 192.168.1.1
PsExecUser = windowsuser
PsExecPass = windowsuserpassword
ConnectVPN = Rasdial vpn_interface user password


Functions
=========
Custom Functions

OpenConsole
Will open CMD in the current folder opened in Windows Explorer

NewTextFile
You like Ctrl+Shift+N to create a new folder in Windows 7? Use Ctrl+Shift+T to create a new text file in current folder.

uTorrentWebUI
Remote control uTorrent running in another machine. Stop, start, pause, unpause, etc...

ConnectVPNRemote
Start VPN connection on the remote machine

PSExecWArgs
Execute commands in remote computer using PSExec using dialog input.

GoogleMusicControl
Simple Google Play Music control start, pause, next, previous. (Opened in Chrome only, for now)

LoopChromeTabs
Go through all opened tabs and find a certain tab in Chrome

