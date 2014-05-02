; Control key  ^
; Alt key      !
; Shift key    +
; Windows key  # 

#IfWinActive, Visual Studio
return

; Open Console2 in current dir
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

; open CMD on root
^#c::
	OpenConsole()
	return

; Create new text file in current dir
#IfWinActive ahk_class ExploreWClass|CabinetWClass
    ^+t::
		NewTextFile()
		return
#IfWinActive

; Open my Notes.txt
^!n::Run, %A_WorkingDir%\..\..\Notes\notes.txt

; Open DropBox folder
^!d::RUN %A_WorkingDir%\..\..\

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


; open PortableApps folder
#IfWinNotActive ahk_class PX_WINDOW_CLASS
^+p::
	Run %PortableApps%
	return

; open Sublime Text
^#s::
	Run %PortableApps%\Sublime\sublime_text.exe
	return