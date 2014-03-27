; Control key  ^
; Alt key      !
; Shift key    +
; Windows key  # 

^!o::
    If A_ComputerName = %workPc%
    {
		Run \\qtfile3\onedrop
		return
	}
	return

^!l::
    If A_ComputerName = %workPc%
    {
		Run E:\TFS\Ver12.00\dev
		return
	}
	return