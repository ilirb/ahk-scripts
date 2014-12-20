; Control key  ^
; Alt key      !
; Shift key    +
; Windows key  #

; ==============================================
; Hotkeys

;~ GroupAdd, DevApps, ahk_exe atom.exe
;~ GroupAdd, DevApps, ahk_exe sublime_text.exe
;~ GroupAdd, DevApps, ahk_exe devenv.exe
;~ #IfWinNotActive ahk_group DevApps

; Open Console2 in current dir, Win+C, or Ctrl+Shift+C
SetTitleMatchMode RegEx
#if WinActive("ahk_class CabinetWClass") Or WinActive("ahk_class Progman")
    #c::
        If A_OSVersion in WIN_8
        {
			Send #c
			return
        }
        else
        {
            OpenConsole()
            return
        }
	^+c::
		OpenConsole()
		return
		
	^+t:: ; Create new text file in current dir, Ctrl+Shift+T
		NewTextFile()
		return
#If

; Open CMD on root, Ctrl+Win+C
^#c::
	OpenConsole()
	return

#IfWinActive ahk_class ExploreWClass|CabinetWClass
    ^!a::
    {
      GetFullPath()
      run, atom "%full_path%", , hide
      return
    }
#IfWinActive

; ==============================================
; Google Music control/Spotify

; Google Music Play/Pause, Ctrl+Alt+Space
;~ #If !(WinActive("ahk_exe atom.exe") Or WinActive("ahk_exe sublime_text.exe") Or WinActive("ahk_exe devenv.exe"))
^!Space::
	{
		If WinExist("ahk_class SpotifyMainWindow")
			SpotifyMusicControl("Space")
		Else
			GoogleMusicControl("Space")
		return
	}
; Google Music Previous song, Ctrl+Alt+Left
^!Left::
	{
		If WinExist("ahk_class SpotifyMainWindow")
			SpotifyMusicControl("Left")
		Else
			GoogleMusicControl("Left")
		return
	}

; Google Music Next song, Ctrl+Alt+Right
^!Right::
	{
		If WinExist("ahk_class SpotifyMainWindow")
			SpotifyMusicControl("Right")
		Else
			GoogleMusicControl("Right")
		return
	}
;~ #If

; ==============================================
; Files and Folders

#If !(WinActive("ahk_exe atom.exe") Or WinActive("ahk_exe sublime_text.exe") Or WinActive("ahk_exe devenv.exe"))
; Open my Notes.txt, Ctrl+Alt+N
^!n::Run, %A_WorkingDir%\..\..\Notes\notes.txt

; Open DropBox folder Ctrl+Alt+D
^!d::RUN %A_WorkingDir%\..\..\

; Open PortableApps folder
^+p::
	Run %PortableApps%
	return

; Open Sublime Text
^#s::
	Run %PortableApps%\Sublime\sublime_text.exe
	return

; Open onedrop folder
^!o::
  If A_ComputerName = %workPc%
	{
		Run \\rd-file\onedrop\
		return
	}
	return

; Add Magnet link from clipboard to uTorrent
^!m::
	{
		AR_Server_Clip2Magnet()
		Return
	}

; Open remote utorrent using Web UI
^!u::run, %uTorrentGui%
#If
