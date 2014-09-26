; Control key  ^
; Alt key      !
; Shift key    +
; Windows key  #

#IfWinActive, Visual Studio
return

; ==============================================
; Hotkeys


; Open Console2 in current dir, Win+C, or Ctrl+Shift+C
SetTitleMatchMode RegEx
; GroupAdd, CMDClassGroup, ahk_class CabinetWClass
; GroupAdd, CMDClassGroup, ahk_class Progman
; #IfWinActive ahk_group CMDClassGroup 
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
#IfWinActive

; Open CMD on root, Ctrl+Win+C
^#c::
	OpenConsole()
	return

; Create new text file in current dir, Ctrl+Shift+T
#IfWinActive ahk_class ExploreWClass|CabinetWClass
    ^+t::
		NewTextFile()
		return
#IfWinActive

; Add Magnet link from clipboard to uTorrent
^!m::
	{
		AR_Server_Clip2Magnet()
		Return
	}

; Open remote utorrent using Web UI
^!u::run, %uTorrentGui%

; ==============================================
; Google Music control/Spotify

; Google Music Play/Pause, Ctrl+Alt+Space
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

; ==============================================
; Files and Folders

; Open my Notes.txt, Ctrl+Alt+N
^!n::Run, %A_WorkingDir%\..\..\Notes\notes.txt

; Open DropBox folder Ctrl+Alt+D
^!d::RUN %A_WorkingDir%\..\..\

; Open PortableApps folder
#If !(WinActive("ahk_exe atom.exe") Or WinActive("ahk_exe sublime_text.exe"))
^+p::
	Run %PortableApps%
	return
#If

; Open Sublime Text
^#s::
	Run %PortableApps%\Sublime\sublime_text.exe
	return

; Open onedrop folder
^!o::
    If A_ComputerName = %workPc%
    {
		Run \\qtfile3\onedrop
		return
	}
	return
