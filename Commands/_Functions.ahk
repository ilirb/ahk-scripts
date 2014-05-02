;========================================================================================
; Opens the command shell 'cmd' in the directory browsed in Explorer.
; Note: expecting to be run when the active window is Explorer.
; 
; If you have defined a custom cmd console in Vars.ahk then it will use that otherwise it will use standard Windows CMD

AddCommand("OpenConsole", "Open Console in Current Folder by pressing Win+C")
OpenConsole()
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
			; Define you cmd console's path %CustomCMD% and its parameter %CustomCMD_args% in Vars.ahk 
			IfExist, %CustomCMD%
				Run, %CustomCMD% %CustomCMD_args% "%full_path%"
			else
				Run,  cmd /K cd /D "%full_path%"
	    }
    else
	    {
	        ; MsgBox Something went wrong, we couldn't figure out the path :O
	        IfExist, %CustomCMD%
				Run, %CustomCMD% %CustomCMD_args% "C:\"
			else
				Run,  cmd /K cd /D "C:\"
	        ; Run, cmd /K cd /D "C:\ "
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
; Google Play Music simple remote control functions
; A bit hacky but it works just fine so i don't think i will revise this, ever? Maybe.
; Windows/Tab title variable for Google Play Music is in Vars.ahk GMusicTabTitle


AddCommand("GoogleMusicControl", "Ctrl+Alt - Space for play/pause, Left for previous and Right for next")
GoogleMusicControl(SendKey)
{
	Global TabTitleExist
	SetTitleMatchMode 2
	IfWinExist, %GMusicTabTitle%
	{
		WinActivate, %GMusicTabTitle%
  		Send {%SendKey%}
		WinMinimize, %GMusicTabTitle%
		return
	}
	LoopChromeTabs(GMusicTabTitle)
	if (TabTitleExist = 1)
	{
		WinActivate, %GMusicTabTitle%
  		Send {%SendKey%}
		WinMinimize, %GMusicTabTitle%
		return
	}
	return
}

LoopChromeTabs(GMusicTabTitle)
{
	Global TabTitleExist
	IfWinExist, ahk_class Chrome_WidgetWin_1
	{
		; Get first open tab title
		WinGetTitle, FirstTitle
		
		; Go through all open tabs and find the tab we are looking for or quit
		Loop
		{
			WinActivate ahk_class Chrome_WidgetWin_1
			Send ^{Tab}
			WinGetTitle, CurrentTitle
			
			; After we changed tab, have we found our tab?
			IfWinExist, %GMusicTabTitle%
			{
				TabTitleExist = 1
				break
			}
			
			; We went through all tabs (because we are at the first ever tab) and we should stop looping
			If (FirstTitle = CurrentTitle)
				break
		}
	}
}

;========================================================================================
AddCommand("IPAddrs", "Show Local IP addresses")
IPAddrs()
	{
		MsgBox, %A_IPAddress1%`n%A_IPAddress2%`n%A_IPAddress3%`n%A_IPAddress4%
	}

AddCommand("ExternalIP", "Show Public IP Address (clipboard)")
ExternalIP()
	{
		UrlDownloadToFile, http://ip.ahk4.me/, %A_Temp%\ip.ahk4.me
		FileRead, ExtIP, %A_Temp%\ip.ahk4.me
		MsgBox % ExtIP
		FileDelete,%A_Temp%\ip.ahk4.me
		Clipboard := ExtIP	
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
; Json functions 
;
; Use CurlFormJson() if the following is desired "curl.exe -s -k -F "x=1x" -F "y=1y" Url
;	use this format to the message: JsonMessage := {x : 1x, y : 1y, z : 1z}
;
; Use CurlDataJson() if the following is desired "curl.exe -i -X POST -d "{x:1x,y:1y}" -H "content-type:application/json" Url
;	use this format: JsonMessage = {"x" : "1x", "y": "2y"}
;
; Always assign the message to variable "JsonMessage"
; Always assign the URL to variable "JsonURL"

CurlFormJson()
	{
		FormString := ""
		for k,v in JsonMessage
			FormString .= (" -F ") . """" . k . "=" . v . """"

		if JsonUser
			SendJsonUser = -u "%JsonUser%": 
		else
			SendJsonUser =

		Run, %curl% -s -k %SendJsonUser% %FormString% %JsonURL%, , hide
		;Clipboard = %curl% -s -k %SendJsonUser% %FormString% %JsonURL% ; Enable to debug cmd
		Return
	}

CurlDataJson()
	{
		
		StringReplace, ParsedJsonMessage, JsonMessage, ", \", 1
		Run, %curl% -i -X POST -d "%ParsedJsonMessage%" -H "content-type:application/json" %JsonURL%, , hide
		return
	}

;; This should probably go away
;
; CurlDataJson()
; 	{
; 		DataString := ""
; 		for k,v in JsonMessage
; 			DataString .= (" \""") . k . "\""" . ": " . "\""" . v . "\"","
; 		StringTrimRight strout, DataString, 1
; 		Run, %curl% -i -X POST -d "{ %strout% }" -H "content-type:application/json" %JsonURL%, , hide
; 	}

;========================================================================================	
; XBMC Remote API using curl and JSON calls
; To be improved for supporting many API calls
; http://wiki.xbmc.org/index.php?title=JSON-RPC_API/v6

AddCommand("XBMCSendMessage", "Send a message to XBMC server")
XBMCSendMessage()
	{
		InputBox, message, "Enter message to send"
		JsonMessage = {"jsonrpc" : "2.0", "method" : "GUI.ShowNotification", "params" : {"title" : "%A_ComputerName%" , "message" : "%message%" }, "id" : "1"}
		; Need to figure out a way to wake up xbmc before sending a message, sending input wakes it but if it's on already it'll send an UP command
		;JsonMessage = "{\"jsonrpc\":\"2.0\",\"method\":\"Input.Up\"}"

		SendToXBMC()
	}

AddCommand("XBMCScanLibrary", "XBMC Scan Library for changes")
XBMCScanLibrary()
	{
		JsonMessage = {"jsonrpc" : "2.0", "method": "VideoLibrary.Scan"}
		SendToXBMC()
	}
	
AddCommand("XBMCCleanLibrary", "XBMC Clean Library")
XBMCCleanLibrary()
	{
		JsonMessage = {"jsonrpc": "2.0", "method": "VideoLibrary.Clean"}
		SendToXBMC()
	}
	
AddCommand("XBMCReboot", "XBMC Reboot")
XBMCReboot()
	{
		JsonMessage = {"jsonrpc": "2.0", "method": "System.Reboot"}
		SendToXBMC()
	}

SendToXBMC()
	{
		JsonURL := xbmcRPC
		CurlDataJson()
		Return
	}

;========================================================================================	
; AutoRemote
; Set AR_Target_Key the key to the device you want to send message to
; Set AR_Message the message you want to send
; blahhhhh

AutoRemoteSend()
	{
		run, %curl% -k "%AR_URL%/sendmessage?key=%AR_TargetKey%&message=%AR_Message%", , hide
		return
	}

AddCommand("AR_Server_VPNStatus", "AutoRemote VPN Status to HomeServer")
AR_Server_VPNStatus()
	{
		AR_TargetKey = %ARkey_homeServer%
		AR_Message := "AHK=:=VPNStatus"
		AutoRemoteSend()
		Return
	}


AddCommand("AR_Server_Custom", "AutoRemote send AHK=:= to HomeServer")
AR_Server_Custom()
	{
		InputBox, args, "AHK=:=", , , , 120, , , , , "Enter only the command after =:="
		AR_TargetKey = %ARkey_homeServer%
		AR_Message := "AHK=:=" . args
		AutoRemoteSend()
		Return
	}

AddCommand("AR_Main_Custom", "AutoRemote send Dell=:= to HomePC")
AR_Main_Custom()
	{
		InputBox, args, "Dell=:=", , , , 120, , , , , "Enter only the command after =:="
		AR_TargetKey = %ARKey_Main%
		AR_Message := "Dell=:=" . args
		AutoRemoteSend()
		Return
	}

;========================================================================================	
; Pushover
; Set AR_Target_Key the key to the device you want to send message to
; Set AR_Message the message you want to send
; blahhhhh

AddCommand("SendMessagePushover", "Send a Pushover message to my HTCOne")
SendMessagePushover()
	{
		JsonURL := PO_PushoverURL
		InputBox, inputmessage, "Message to HTCOne", , , , 120, , , , , "Enter your message"
		JsonMessage := {token : PO_Token, user : PO_User, message : inputmessage, device : PO_Device, title : AHK}
		CurlFormJson()
		Return
	}

;========================================================================================	
; PushBullet ; variables: PB_Key (api key), PB_PushUrl, PB_Device
; Usually 

AddCommand("PushBulletChrome", "Send a PushBullet message to chrome")
PushBulletChrome()
	{
		JsonURL := PB_PushUrl ; static
		JsonUser := PB_Key ; static
		PB_Device := PB_Chrome ; change to desired device
		InputBox, inputmessage, "Message to Chrome", , , , 120, , , , , "Enter your message"

		JsonMessage := {"device_iden" : (PB_Device), "type": "note", "title" : "AHK" , "body" : (inputmessage)}
		CurlFormJson()
		Return
	}