; General variables
EnvGet, ProgFiles32, ProgramFiles(x86)
if ProgFiles32 = ; Probably not on a 64-bit system.
	EnvGet, ProgFiles32, ProgramFiles
EnvGet, ProgFiles64, ProgramW6432
; Use ProgFiles32 var on any OS architecture x86/x64 to get to "Program Files x86" on x64 and "Program Files" on x86
; Example eventghost := ProgFiles32 . "\EventGhost\EventGhost.exe -e"

; Computers - add as many as you like, remmember to define Folders also for each computer
global workPC := "YOUR-WORK-COMPUTER-NAME"
global homePC := "YOUR-HOME-COMPUTER-NAME"
;global HomeServer := "YOUR-SERVER-COMPUTER-NAME"

; Folders
global DropBox := A_ScriptDir . "\..\..\" ; use this is if this AHK script reside in DropBox or enter an absolute path like "x:\PATH\TO\DROPBOX"

If A_ComputerName = %workPc%
    {
		global PortableApps := "X:\PATH\TO\PortableApps"
		global SysInternals := "X:\PATH\TO\SysinternalsSuite"
		global NirSoft := "X:\PATH\TO\NirSoft"
	}
	else if A_ComputerName = %homePC%
	{
		global PortableApps := "X:\PATH\TO\PortableApps"
		global SysInternals := "X:\PATH\TO\SysinternalsSuite"
		global NirSoft := "X:\PATH\TO\NirSoft"
	}
;	else if A_ComputerName = %HomeServer%
;	{
;		global PortableApps := "X:\PATH\TO\PortableApps"
;		global SysInternals := "X:\PATH\TO\SysinternalsSuite"
;		global NirSoft := "X:\PATH\TO\NirSoft"
;	}
	else
	{
		MsgBox PortableApps, SysInternals and NirSoft folders are not defined for this computer %A_ComputerName% `n`nPlease edit %A_ScriptDir%\Vars.ahk
	}

; Tools
global curl := A_ScriptDir . "\..\..\Tools\curl32.exe"
global eventghost := ProgFiles32 . "\EventGhost\EventGhost.exe -e" ; send message to eventghost cmd

; Custom CMD console
global CustomCMD := A_ScriptDir . "\..\..\Tools\cmder\Cmder.exe" ; cmder
global CustomCMD_args := "/start" ; cmder open path argument 

; home server
global RemoteComputer := "IP-ADDRESS"
global PsExecUser := "WINDOWS USER"
global PsExecPass := "PASSWORD"
global ConnectVPN := "Rasdial VPNNAME USERNAME PASSWORD" ; VPNNAME is the name of the connection you create on Windows
global CloseVPN := "Rasdial VPNNAME /DISCONNECT"
global MacList := "HomePc|nn-nn-nn-nn-nn-nn,RaspberryPi|nn-nn-nn-nn-nn-nn"

; uTorrent
global uTorrentIP := "IPADDRESS-TORRENT"
global uTorrentPort := "PORT"
global Magnet := "%Clipboard%"
global uTorUser := "USER"
global uTorPass := "PASSWORD"

; xmbc
global xbmcuser := "" ; leave blank if you don't have username set on xbmc
global xbmcpass := "" ; leave blank if you don't have password 
global xbmcIP := "IPADDRESS-XBMC"
global xbmcJSONPort := "PORT"
global xbmcRPC
xbmcRPC = http://%xbmcIP%:%xbmcJSONPort%/jsonrpc

; AutoRemote
global AR_TargetKey, AR_Message
global AR_URL := "https://autoremotejoaomgcd.appspot.com"
global ARkey_homeServer := "PUT-YOUR-KEY-HERE"
global ARKey_Main := "PUT-YOUR-KEY-HERE"

; PushBullet
global PB_Key := "PUT-YOUR-KEY-HERE"
global PB_PushUrl := "https://api.pushbullet.com/api/pushes"
global PB_Chrome := "YOUR-DEVICE-ID"
global PB_HTCOne := "YOUR-DEVICE-ID"
global MessageTitle, MessageBody, JsonUser

; Other variables
global GMusicTabTitle := "Google Play Music"
global JsonURL
global JsonMessage