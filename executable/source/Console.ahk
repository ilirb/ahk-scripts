SetTitleMatchMode RegEx
MsgBox, 64, OpenConsole, USAGE: When in a folder in Windows Explorer press Win + C or Ctrl + Shift + C to open CMD in that folder.`n`nINFO: To use another console like Console2 have it in the same folder as this script and same filename \Console\Console.exe (e.g. D:\Tools\Console\Console.exe)

#IfWinActive ahk_class ExploreWClass|CabinetWClass
    #c::
        If A_OSVersion in WIN_8
        {
			Send #c
            return
        }
        else
        {
            OpenConsole2()
            return
        }
		
	^+c::	
		OpenConsole2()
		return
#IfWinActive

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
		IfExist, %A_WorkingDir%\Console\Console.exe
            Run, %A_WorkingDir%\Console\Console.exe -d "%full_path%"
        else 
            Run, cmd /K cd /D "%full_path%"
    }
    else
    {
        MsgBox Something went wrong, we couldn't figure out the path :O
        Run, cmd /K cd /D "C:\ "
    }
}