SetTitleMatchMode RegEx
MsgBox, 64, NewTextFile, USAGE: When in a folder in Windows Explorer press Ctrl + Shift + T to create empty text file.`nIf you press multiple times, multiple files will be created (e.g. NewTextFile0.txt, NewTextFile1.txt)

#IfWinActive ahk_class ExploreWClass|CabinetWClass
    ^+t::
		NewTextFile()
		return
#IfWinActive

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