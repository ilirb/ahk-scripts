; Control key  ^
; Alt key      !
; Shift key    +
; Windows key  # 

;~ ^!s::RUN \\selun-ibi\Shared
;~ ^!x::RUN C:\Users\ibi\Downloads


^!o::
    If A_ComputerName = SELUN-IBI
    {
		Run \\qtfile3\onedrop
		return
	}
	return

^!l::
    If A_ComputerName = SELUN-IBI
    {
		Run D:\Ver12.00\dev
		return
	}
	return