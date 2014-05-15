SetTitleMatchMode RegEx
MsgBox, 64, OpenConsole, USAGE: When in a folder in Windows Explorer press Win + C or Ctrl + Shift + C to open CMD in that folder.`n`nINFO: To use another console like Cmder, Console2 or any other one edit Console.ini where you enter the path to your CMD of choice. To use another CMD Console.exe and Console.ini have to be in the same folder.

global CustomCMD, CustomCMD_args

SplitPath, A_ScriptFullPath, name, dir, ext, name_no_ext, drive

IniRead, CustomCMD, %A_ScriptDir%\%name_no_ext%.ini, CustomCMD, , %A_Space%
IniRead, CustomCMD_args, %A_ScriptDir%\%name_no_ext%.ini, Arguments, , %A_Space%

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
		
	^+c::
		OpenConsole()
		return
#IfWinActive

; Open CMD on root, Ctrl+Win+C
^#c::
	OpenConsole()
	return

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