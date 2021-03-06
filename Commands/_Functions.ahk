;========================================================================================
; Functions to run against a folder opened in Windows Explorer
; full_path - is the variable returned with the full path

global full_path
GetFullPath() ; Use this function to get the Absolute path of a folder opened in Windows Explorer
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
			return full_path
		}
	else if (WinActive("ahk_class Progman"))
		{
			full_path = %A_Desktop%
			return full_path
		}
	else if full_path = Downloads
		{
			EnvGet, UserProfile, UserProfile
			full_path = %UserProfile%\Downloads
      return full_path
		}
	else
		{
			full_path =
			return full_path
		}
}

; Opens the command shell 'cmd' in the directory browsed in Explorer.
; Note: expecting to be run when the active window is Explorer.
; If you have defined a custom cmd console in Vars.ahk then it will use that otherwise it will use standard Windows CMD
AddCommand("OpenConsole", "Open Console in Current Folder by pressing Win+C")
OpenConsole()
{
	GetFullPath()
    If full_path
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
	GetFullPath()
	If full_path
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
  else return
}

;========================================================================================
;OLD AND PROBABLY BROKEN
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
	URLDownloadToFile, %uTorrentGui%/?list=1, %A_ScriptDir%\list.txt

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
				Run, %uTorrentGui%/?action=%ActionToPerform%&hash=%TorrentHash%
			}
		}
	}
	FileDelete, %A_ScriptDir%\list.txt
}

uTorrentMagnet(magnetURL)
{
	;TODO set labels
	Run, %uTorrentGui%/?action=add-url&s=%magnetURL%

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
	; Open the Google Play music if it's not running.
	run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  --profile-directory=Default --app-id=icppfcnhkcmnfdhfhphakoifcfokfdhg
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
;Spotify simple Controls

SpotifyMusicControl(SendKey)
{
	DetectHiddenWindows, On
	If SendKey = Space
		{
			ControlSend, ahk_parent, {Space}, ahk_class SpotifyMainWindow
		}
	Else
		{
			ControlSend, ahk_parent, ^{%SendKey%}, ahk_class SpotifyMainWindow
		}
	DetectHiddenWindows, Off
	return
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
		; Clipboard = %curl% -s -k %SendJsonUser% %FormString% %JsonURL% ; Enable to debug cmd
		Return
	}

CurlDataJson()
	{
		StringReplace, ParsedJsonMessage, JsonMessage, ", \", 1
		Run, %curl% -i -X POST -d "%ParsedJsonMessage%" -H "content-type:application/json" %JsonURL%, , hide
		; Clipboard = %curl% -i -X POST -d "%ParsedJsonMessage%" -H "content-type:application/json" %JsonURL% ; Enable to debug cmd
		return
	}
