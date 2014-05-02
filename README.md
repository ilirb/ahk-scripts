ahk-scripts
===========

Different AHK scripts (also included in AHK Command Picker) and few compiled standalone EXE's (without AutoHotKey)

What's in here
--------------

AHK Command Picker 1.3.1 - http://ahkcommandpicker.codeplex.com/

It's pretty much unmodified so i strongly recommend you to read doc @ http://ahkcommandpicker.codeplex.com/documentation to get you started on what AHK Command Picker is and how to use it.


Besides AHK CmdPicker's general shortcuts/hotkeys i have included my own Functions and shortcuts which are suited to me so if you want to use everything you will have to adjust them for your needs.

Next are `Executables` which are basically exe files and you can run them without having AutoHotKey installed. Should come in handy when you want these scripts but cannot install AHK. I have also included `source` for all those exe's incase you wonder what's inside or want to improve.

How To
------
Run AHKCommandPicker.ahk and activate it by pressing `Caps-Lock` (you are really not using it)

In `Commands` folder all files with underscore are my additions you can check their content for more detail.

For some functions like uTorrent, PSExec, Folder/App shortcuts copy Vars.ahk to one folder above the current folder (`..\Vars.ahk`) and adjust variables to your needs.
    
For `EXE`'s just run them and you'll get a msgbox with instructions.

Functions
---------
Custom Functions

* **OpenConsole** - 
Will open CMD in the current folder opened in Windows Explorer.

* **NewTextFile** - 
You like build-in `Ctrl+Shift+N` to create a new folder in Windows 7? Use `Ctrl+Shift+T` to create a new text file in current folder.

* **uTorrentWebUI** - 
Remote control uTorrent running in another machine. Stop, start, pause, unpause, etc...

* **ConnectVPNRemote** - 
Start VPN connection on the remote machine.

* **PSExecWArgs** - Execute commands in remote computer using PSExec using dialog input.

* **GoogleMusicControl** - Simple Google Play Music control start, pause, next, previous. (Opened in Chrome only, for now)

* **LoopChromeTabs** - Go through all opened tabs and find a certain tab in Chrome.

* **WakeOnLan** - Put all your machines in a list and wake 'em up remotely each one separately.

* **XBMC Remote** - Control your XBMC Media Center 

* **AutoRemote, Pushover, Pushbullet** - Use these services to send messages to your devices.


Shortcut tips
--------------------

* On Windows Explorer

`Win+C` open a CMD at the current path.

`Ctrl+Shift+T` create new Text file in current folder, each time you press it will create new file.

`Ctrl+Win+C` open CMD from everywhere, no need to be in Windows Explorer.

* Google Play Music

`Ctrl+Alt+Space` Pause/Unpause

`Ctrl+Alt+RightKey` Next song

`Ctrl+Alt+LeftKey` Previous song

* Press `CapsLock`

Type `IP` to get two options, get Local ip addresses and External ip address (also copying it in clipboard)