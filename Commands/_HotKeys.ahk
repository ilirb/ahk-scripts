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
#IfWinActive ahk_class ExploreWClass|CabinetWClass
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
; Google Music control

; Google Music Play/Pause, Ctrl+Alt+Space
^!Space::
	{
		GoogleMusicControl("Space")
		return
	}
; Google Music Previous song, Ctrl+Alt+Left
^!Left::
	{
		GoogleMusicControl("Left")
		return
	}
	
; Google Music Next song, Ctrl+Alt+Right
^!Right::
	{
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
#IfWinNotActive ahk_class PX_WINDOW_CLASS
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
		Run \\qtfile3\onedrop
		return
	}
	return