; General variables
EnvGet, ProgFiles32, ProgramFiles(x86)
if ProgFiles32 = ; Probably not on a 64-bit system.
	EnvGet, ProgFiles32, ProgramFiles
EnvGet, ProgFiles64, ProgramW6432
;; Example eventghost := ProgFiles32 . "\EventGhost\EventGhost.exe -e"

; Computers - add as many as you like, remmember to define Folders also for each computer
global workPC := "YOUR-WORK-COMPUTER-NAME"
global homePC := "YOUR-HOME-COMPUTER-NAME"
;global HomeServer := "YOUR-SERVER-COMPUTER-NAME"

; Folders
global DropBox := A_ScriptDir . "\..\..\" ; use this is your AHK scripts reside in DropBox or enter an absolute path like "x:\PATH\TO\DROPBOX"

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
		MsgBox PortableApps and SysInternals are not defined for this computer %A_ComputerName% `n`nPlease edit %A_ScriptDir%\Vars.ahk
	}

; Tools
global curl := A_ScriptDir . "\..\..\Tools\curl32.exe"
global myPush := A_ScriptDir . "\..\..\Pushover\myPush.exe" ; pushover

; home server
global RemoteComputer := "IP-ADDRESS"
global PsExecUser := "WINDOWS USER"
global PsExecPass := "PASSWORD"
global ConnectVPN := "Rasdial VPNNAME USERNAME PASSWORD"
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