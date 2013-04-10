MsgBox, 64, GoogleMusicRemote, USAGE: When Google Play Music is open in a Chrome browser press Ctrl+Alt+Space to Pause/Play, Ctrl+Alt+Left to play Previous song, Ctrl+Alt+Right to skip song. `n `n I really recommend having Google Play Music separate from other tabs in browser to be more efficient. Hint: Meny - Tools - Create application shortcut... from Chrome Browser.


;Google Music Play/Pause, Ctrl+Alt+Space
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