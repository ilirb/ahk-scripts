; Control key  ^
; Alt key      !
; Shift key    +
; Windows key  # 

;~ ^!s::RUN \\selun-ibi\Shared
;~ ^!x::RUN C:\Users\ibi\Downloads


^!o::
    If A_ComputerName = SELUN-IBI1
    {
		Run \\qtfile3\onedrop
		return
	}
	return

^!l::
    If A_ComputerName = SELUN-IBI1
    {
		Run E:\TFS\Ver12.00\dev
		return
	}
	return
	
#IfWinNotActive ahk_class PX_WINDOW_CLASS
^+p::
    If A_ComputerName = SELUN-IBI1
    {
		Run C:\Users\ibi\Documents\Portable\PortableApps
		return
		
	}
	return
	
^#s::
	Run %PortableApps%\Sublime\sublime_text.exe
	return