AddCommand("OpenConsole2", "Open Console2 in Current Folder by pressing Win+C")
OpenConsole2()
{
    ; This is required to get the full path of the file from the address bar
    WinGetText, full_path, A

    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n
	Loop, %word_array0%
	{
		IfInString, word_array%A_Index%, Address
		{
			full_path := word_array%A_Index%
			break
		}
	}   

    ; strip to bare address
    full_path := RegExReplace(full_path, "^Address: ", "")

    ; Just in case - remove all carriage returns (`r)
    StringReplace, full_path, full_path, `r, , all


    IfInString full_path, \
    {
		; This will run a custom cmd called Console2 if you want to use the regular one use the 2nd line instead
		IfExist, %A_WorkingDir%\..\..\Tools\Console-2.00b148-Beta_32bit\Console.exe
			Run, %A_WorkingDir%\..\..\Tools\Console-2.00b148-Beta_32bit\Console.exe -d "%full_path%"
		else
			Run,  cmd /K cd /D "%full_path%"
    }
    else
    {
        MsgBox Something went wrong, we couldn't figure out the path :O
        Run, cmd /K cd /D "C:\ "
    }
}

AddCommand("NewTextFile", "Creates a new text file in Current Folder by pressing Ctrl+Shift+T")
NewTextFile()
{
    WinGetText, full_path, A
    StringSplit, word_array, full_path, `n
    Loop, %word_array0%
	{
		IfInString, word_array%A_Index%, Address
		{
			full_path := word_array%A_Index%
			break
		}
	} 
    full_path := RegExReplace(full_path, "^Address: ", "")
    StringReplace, full_path, full_path, `r, , all
    
    IfInString full_path, \
    {
        NoFile = 0
        Loop
        {
            IfExist  %full_path%\NewTextFile%NoFile%.txt
                    NoFile++
                else
                    break
        }
        FileAppend, ,%full_path%\NewTextFile%NoFile%.txt
    }
    else
    {
        return
    }
}

;========================================================================================
; Opens the command shell 'cmd' in the directory browsed in Explorer.
; Note: expecting to be run when the active window is Explorer.
;
OpenCmdInCurrent()
{
    ; This is required to get the full path of the file from the address bar
    WinGetText, full_path, A

    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n
    ; Take the first element from the array
    	Loop, %word_array0%
	{
		IfInString, word_array%A_Index%, Address
		{
			full_path := word_array%A_Index%
			break
		}
	}

    ; strip to bare address
    full_path := RegExReplace(full_path, "^Address: ", "")

    ; Just in case - remove all carriage returns (`r)
    StringReplace, full_path, full_path, `r, , all


    IfInString full_path, \
    {
        Run,  cmd /K cd /D "%full_path%"
    }
    else
    {
        Run, cmd /K cd /D "C:\ "
    }
}
;========================================================================================
;uTorrent WebUI API
;
;set a variable Action to stop, start, pause, unpause, etc then call this functions
;you need to have username, password, ip, port defined somewhere before calling this.
; E.g.
;
;~ ^+q::
;~ {
	;~ ; send parameters to function like stop, start, pause, unpause, etc 
	;~ uTorrentWebUI("stop")
	;~ return
;~ }

uTorrentWebUI(ActionToPerform)
{
	; Define these variables uTorUser, uTorPass, uTorrentIP, uTorrentPort
	; Get list of torrents
	URLDownloadToFile, http://%uTorUser%:%uTorPass%@%uTorrentIP%:%uTorrentPort%/gui/?list=1, %A_ScriptDir%\list.txt
	
	; Parse the text file to get all torrents and perform desired action against all torrents
	Loop, read, %A_ScriptDir%\list.txt
	{
		; Find the lines that start with [
		Line1 = [
		StringLeft, HashLine, A_LoopReadLine, 1
		
		If HashLine = %Line1%
		{
			; Split the line using the comma separator
			StringSplit, Hash, A_LoopReadLine, `,
			
			; Strip [" from the beggining and " at the end of the hash
			StringTrimLeft, HL, Hash1, 2
			StringTrimRight, TorrentHash, HL, 1
			
			; Hashes are 40 chars long adjust if neccessary
			Length := StrLen(TorrentHash)
			If Length = 40
			{
				Run, http://%uTorUser%:%uTorPass%@%uTorrentIP%:%uTorrentPort%/gui/?action=%ActionToPerform%&hash=%TorrentHash%
			}
		}
	}
	FileDelete, %A_ScriptDir%\list.txt
}
;========================================================================================
AddCommand("ConnectVPNRemote", "Start VPN connection on remote computer - CTRL-Alt-V")
ConnectVPNRemote()
{
	; Define these variables SysInternals, RemoteComputer, PsExecUser, PsExecPass, ConnectVPN
	; ConnectVPN is a cmd: Rasdial vpn_name user pass
	RunWait, %SysInternals%\psexec.exe \\%RemoteComputer% -u %PsExecUser% -p %PsExecPass% cmd /C %ConnectVPN% 
}

AddCommand("CloseVPNRemote", "Close VPN connection on remote computer")
CloseVPNRemote()
{
	; Define these variables SysInternals, RemoteComputer, PsExecUser, PsExecPass, CloseVPN
	; CloseVPN is a cmd: Rasdial vpn_name /DISCONNECT
	RunWait, %SysInternals%\psexec.exe \\%RemoteComputer% -u %PsExecUser% -p %PsExecPass% cmd /C %CloseVPN% 
}

AddCommand("PSexecWArgs", "Enter argument to exec psexec on remote computer - CTRL-Alt-R")
PSexecWArgs()
{
	InputBox, Arguments
	RunWait, %SysInternals%\psexec.exe \\%RemoteComputer% -u %PsExecUser% -p %PsExecPass% cmd /C %Arguments% 
}
;========================================================================================
; WIP
;
; This is ugly, can we have some makeup?

AddCommand("GoogleMusicControl", "Ctrl+Alt - Space for play/pause, Left for previous and Right for next")
GoogleMusicControl(SendKey)
{
	Global TabTitleExist
	TabTitle = My Library - Google Play
	SetTitleMatchMode 2
	IfWinExist, %TabTitle%
	{
		WinActivate, %TabTitle%
  		Send {%SendKey%}
		WinMinimize, %TabTitle%
		return
	}
	LoopChromeTabs(TabTitle)
	if (TabTitleExist = 1)
	{
		WinActivate, %TabTitle%
  		Send {%SendKey%}
		WinMinimize, %TabTitle%
		return
	}
	return
}

LoopChromeTabs(TabTitle)
{
	Global TabTitleExist
	IfWinExist, ahk_class Chrome_WidgetWin_1
	{
		; Get current open tab title
		WinGetTitle, FirstTitle
		
		; Go through all open tabs and find the tab we are looking for or quit
		Loop
		{
			WinActivate ahk_class Chrome_WidgetWin_1
			Send ^{Tab}
			WinGetTitle, CurrentTitle
			
			; After we changed tab have we found our tab?
			IfWinExist, %TabTitle%
			{
				TabTitleExist = 1
				break
			}
			
			; We went through all tabs and we should stop there
			If (FirstTitle = CurrentTitle)
				break
		}
	}
}

;========================================================================================
AddCommand("Kitty", "Open Kitty")
Kitty()
	{
		Run, D:\Portable\PortableApps\Kitty\kitty_portable.exe
	}

AddCommand("Pidgin", "Open Pidgin")
Pidgin()
	{
		Run, D:\Portable\PortableApps\PidginPortable\PidginPortable.exe
	}
    
AddCommand("Winscp", "Open Winscp")
Winscp()
	{
		Run, D:\Portable\PortableApps\WinSCP\winscp422.exe
	}
	
AddCommand("ProcExp", "Open Process Explorer from SysInternals")
ProcExp()
	{
		
		Run, %SysInternals%\procexp.exe
	}

AddCommand("FileZila", "Open FileZila")
FileZila()
	{
		Run, D:\Portable\PortableApps\FileZillaPortable\FileZillaPortable.exe
	}
;========================================================================================	
; Wake On Lan 
; MacList variable is defined in my ..\Vars.ahk files in the following format
; HomePc|00-11-22-33-44-55,RaspberryPi|00-11-22-33-44-55
; Requires WakeMeOnLan from NirSoft. Of course you can use another app just figure out the cmd parameters and change the function

AddCommand("WakeOnLan", "Wake On Lan with parameters", MacList)
WakeOnLan(WOLList = "")
{
	Run, %NirSoft%\WakeMeOnLan.exe /wakeup %WOLList%
	MsgBox Trying to wake: %WOLList%
}
;========================================================================================	
; XBMC Remote API using curl and JSON calls
; To be improved for supporting many API calls
JsonMessage = "{\"jsonrpc\":\"2.0\",\"method\":\"GUI.ShowNotification\",\"params\":{\"title\":\"Message Title\",\"message\":\"Message Body\"},\"id\":1}"
AddParameterToString(JsonXBMC, "Reboot|test")
AddParameterToString(JsonXBMC, "Message|%JsonMessage%")

;AddCommand("XBMCScanLibrary", "XBMC Scan Library for changes", JsonXBMC)
;XBMCScanLibrary(JsonXBMCCalls = "")
AddCommand("XBMCScanLibrary", "XBMC Scan Library for changes")
XBMCScanLibrary()
	{
		;http://%xbmcuser%:%xbmcpass%@%xbmcIP%:%xbmcJSONPort%/jsonrpc ;if you have user and pass
		JsonScanXbmc = "{\"jsonrpc\": \"2.0\", \"method\": \"VideoLibrary.Scan\", \"id\": \"mybash\"}"
		JsonRebootXbmc = "{\"jsonrpc\": \"2.0\", \"method\": \"System.Reboot\", \"id\": \"mybash\"}"
		JsonCleanLibXbmc = "{\"jsonrpc\": \"2.0\", \"method\": \"VideoLibrary.Clean\", \"id\": \"mybash\"}"
		Run, %curl% -i -X POST -d %JsonScanXbmc% -H "content-type:application/json" http://%xbmcIP%:%xbmcJSONPort%/jsonrpc
	}
	
AddCommand("XBMCCleanLibrary", "XBMC Clean Library")
XBMCCleanLibrary()
	{
		JsonCleanLibXbmc = "{\"jsonrpc\": \"2.0\", \"method\": \"VideoLibrary.Clean\", \"id\": \"mybash\"}"
		Run, %curl% -i -X POST -d %JsonCleanLibXbmc% -H "content-type:application/json" http://%xbmcIP%:%xbmcJSONPort%/jsonrpc
	}
	
AddCommand("XBMCReboot", "XBMC Reboot")
XBMCReboot()
	{
		JsonRebootXbmc = "{\"jsonrpc\": \"2.0\", \"method\": \"System.Reboot\", \"id\": \"mybash\"}"
		Run, %curl% -i -X POST -d %JsonRebootXbmc% -H "content-type:application/json" http://%xbmcIP%:%xbmcJSONPort%/jsonrpc
	}