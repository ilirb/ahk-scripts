; Control key  ^
; Alt key      !
; Shift key    +
; Windows key  #

global CustomCMD, CustomCMD_args, full_path

CustomCMD = E:\MyStuff\Dropbox\Tools\cmder\Cmder.exe
CustomCMD_args = /start

; Open Console in current dir, Win+C, or Ctrl+Shift+C
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
#IfWinActive

^#c::
	OpenConsole()
	return

OpenConsole()
{
	GetFullPath()
    If full_path
	    {
			IfExist, %CustomCMD%
				Run, %CustomCMD% %CustomCMD_args% "%full_path%"
			else
				Run,  cmd /K cd /D "%full_path%"
	    }
	else if (WinActive("ahk_class Progman"))
		{
			IfExist, %CustomCMD%
				Run, %CustomCMD% %CustomCMD_args% "%A_Desktop%"
			else
				Run,  cmd /K cd /D "%A_Desktop%"
		}
    else
	    {
	        IfExist, %CustomCMD%
				Run, %CustomCMD% %CustomCMD_args% "C:\ "
			else
				Run,  cmd /K cd /D "C:\ "
	    }
}

GetFullPath() ; Use this function to get the Absolute path of a folder opened in Windows Explorer
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
			return full_path
		}
	else
		{
			full_path =
			return full_path
		}
}