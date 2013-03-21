MsgBox, 64, NetConnectionMonitor, USAGE: Every 10 sec the scripts checks if you are connected to a network (e.g. VPN) and start an app of your choice otherwise it will close the app until connection is established again.  `n`nEdit NetConnectionMonitor.ini to configure the app and networks.

Loop
{
	IniRead, VPNIP, %A_ScriptDir%\NetConnectionMonitor.ini, IP, , %A_Space%
	IniRead, app, %A_ScriptDir%\NetConnectionMonitor.ini, App, , %A_Space%
	IniRead, appFullPath, %A_ScriptDir%\NetConnectionMonitor.ini, appFullPath, , %A_Space%
	
	global Connected, app, appFullPath, VPNIP
	Process, Exist, %app%
	AppRunning = %ErrorLevel%
	Sleep, 10000
	CheckIP()
	If (Connected = 1)
		{
		If (AppRunning = 0) ; If it is not running
			{
			Run, %appFullPath%
			;Bother = 1
			}
		else
		continue
		}	
	else
	{
		If (AppRunning > 0)
		{
			;ConnectToVPN()
			Process, Close, %app%
		}
		;else
			;ConnectToVPN()		
	}
}

CheckIP() ;checks if we are connected to VPN and set variable Connected to 0|1
{
	StringSplit, IPArray, VPNIP, `n,%A_Space%
	LocalIP = %A_IPAddress1%,%A_IPAddress2%,%A_IPAddress3%,%A_IPAddress4%
	Matches = 0
	Loop, %IPArray0%
	{
		Each := IPArray%A_Index%
		IfInString, LocalIP, %Each%
			Matches++
	}
	If Matches > 0
		Connected = 1
	else
		Connected = 0
}

; Unused function, maybe have parameters to swith it on/off so it auto connects if connects drops or just watch for connections.
ConnectToVPN()
{
		global Connected, Bother
		
		If (Connected = 0 and Bother > 0)
			MsgBox, 52, VPN, You are not connected, do you want to connect?
			IfMsgBox Yes
				RunWait, Rasdial vpn user pass
			IfMsgBox No
				Bother = 0
}