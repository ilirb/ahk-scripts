;========================================================================================
AddCommand("IP_LocalAddrs", "Show Local IP addresses")
IP_LocalAddrs()
	{
		EnvGet, UserDNSDomain, USERDNSDOMAIN
		EnvGet, UserDomain, USERDOMAIN
		Gui, 5:Default
		Gui, Add, Text, , Computer Name: %A_ComputerName%
		Gui, Add, Text, , UserName: %A_UserName%
		Gui, Add, Text, , DNS Domain: %USERDNSDOMAIN%
		Gui, Add, Text, , Domain: %USERDOMAIN%

		Gui, Add, Text, y+20 x20 , %A_IPAddress1%
		Gui, Add, Button, x+5 yp-5 gcopyIP1 , Copy
		Gui, Add, Text, y+10 x20 , %A_IPAddress2%
		Gui, Add, Button, x+5 yp-5 gcopyIP2 , Copy
		Gui, Add, Text, y+10 x20 , %A_IPAddress3%
		Gui, Add, Button, x+5 yp-5 gcopyIP3 , Copy
		Gui, Add, Text, y+10 x20 , %A_IPAddress4%
		Gui, Add, Button, x+5 yp-5 gcopyIP4 , Copy

		Gui, Show, w+300 , Local IP Addresses
		return

		copyIP1:
		    {
		        Clipboard = %A_IPAddress1%
		        gui, 5:Destroy
		        Return
		    }

		copyIP2:
		    {
		        Clipboard = %A_IPAddress2%
		        gui, 5:Destroy
		        Return
		    }

		copyIP3:
		    {
		        Clipboard = %A_IPAddress3%
		        gui, 5:Destroy
		        Return
		    }

		copyIP4:
		    {
		        Clipboard = %A_IPAddress4%
		        gui, 5:Destroy
		        Return
		    }

		    5GuiClose: ; If X is pressed close the window ; note the 5 before GuiClose
			Gui,5:destroy
			return

			5GuiEscape: ; If ESC is pressed close the window
			Gui,5:Destroy
			Return
	}

AddCommand("IP_Public", "Show Public IP Address and put it in clipboard")
IP_Public()
	{
		UrlDownloadToFile, http://ip.ahk4.me/, %A_Temp%\ip.ahk4.me
		FileRead, ExtIP, %A_Temp%\ip.ahk4.me
		MsgBox % "PublicIP: " ExtIP
		FileDelete,%A_Temp%\ip.ahk4.me
		Clipboard := ExtIP
	}

AddCommand("Sleep", "Suspends the computer, Sleep.")
Sleep()
	{
		DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
	}

;========================================================================================
; Wake On Lan
; MacList variable is defined in my ..\Vars.ahk files in the following format
; HomePc|00-11-22-33-44-55,RaspberryPi|00-11-22-33-44-55
; Requires WakeMeOnLan from NirSoft. Of course you can use another app just figure out the cmd parameters and change the function

AddCommand("WakeOnLan", "Wake On Lan with parameters", MacList)
WakeOnLan(WOLList = "")
{
	Run, %NirSoft%\WakeMeOnLan.exe /wakeup %WOLList%
	MsgBox Trying to wake: %WOLList%
}

;========================================================================================
; PSExec commands

; Need to make it more interactive and general. Accept computername, user, pass, arguments.
AddCommand("PSexecWArgs", "Enter argument to exec psexec on remote computer - CTRL-Alt-R")
PSexecWArgs()
{
	InputBox, Arguments
	RunWait, %SysInternals%\psexec.exe \\%RemoteComputer% -u %PsExecUser% -p %PsExecPass% cmd /C %Arguments%
}

AddCommand("ProcessExplorer", "Start SysInternals Process Explorer in admin")
ProcessExplorer()
{
	Run, %SysInternals%\procexp.exe /e
}

;========================================================================================
; XBMC Remote API using curl and JSON calls
; To be improved for supporting many API calls
; http://wiki.xbmc.org/index.php?title=JSON-RPC_API/v6

AddCommand("XBMCSendMessage", "Send a message to XBMC server")
XBMCSendMessage()
	{
		InputBox, message, "Enter message to send"
		JsonMessage = {"jsonrpc" : "2.0", "method" : "GUI.ShowNotification", "params" : {"title" : "%A_ComputerName%" , "message" : "%message%" }, "id" : "1"}
		; Need to figure out a way to wake up xbmc before sending a message, sending input wakes it but if it's on already it'll send an UP command
		;JsonMessage = "{\"jsonrpc\":\"2.0\",\"method\":\"Input.Up\"}"

		SendToXBMC()
	}

AddCommand("XBMCScanLibrary", "XBMC Scan Library for changes")
XBMCScanLibrary()
	{
		JsonMessage = {"jsonrpc" : "2.0", "method": "VideoLibrary.Scan"}
		SendToXBMC()
	}

AddCommand("XBMCCleanLibrary", "XBMC Clean Library")
XBMCCleanLibrary()
	{
		JsonMessage = {"jsonrpc": "2.0", "method": "VideoLibrary.Clean"}
		SendToXBMC()
	}

AddCommand("XBMCReboot", "XBMC Reboot")
XBMCReboot()
	{
		JsonMessage = {"jsonrpc": "2.0", "method": "System.Reboot"}
		SendToXBMC()
	}

AddCommand("XBMCInputBack", "XBMC send Back input")
XBMCInputBack()
	{
		JsonMessage = {"jsonrpc": "2.0", "method": "Input.Back"}
		SendToXBMC()
	}

SendToXBMC()
	{
		JsonURL := xbmcRPC
		CurlDataJson()
	}

;========================================================================================
; AutoRemote
; Set AR_Target_Key the key to the device you want to send message to
; Set AR_Message the message you want to send
; blahhhhh

AutoRemoteSend()
	{
		run, %curl% -k "%AR_URL%/sendmessage?key=%AR_TargetKey%&message=%AR_Message%", , hide
	}

AddCommand("AR_Server_VPNStatus", "AutoRemote VPN Status to HomeServer")
AR_Server_VPNStatus()
	{
		AR_TargetKey = %ARkey_homeServer%
		AR_Message := "AHK=:=VPNStatus"
		AutoRemoteSend()
	}

AddCommand("AR_Server_Custom", "AutoRemote send AHK=:= to HomeServer")
AR_Server_Custom()
	{
		InputBox, args, "AHK=:=", , , , 120, , , , , "Enter only the command after =:="
		AR_TargetKey = %ARkey_homeServer%
		AR_Message := "AHK=:=" . args
		AutoRemoteSend()
	}

AddCommand("AR_Server_Clip2Magnet", "Send Magnet link from clipboard to Home Server.")
AR_Server_Clip2Magnet()
	{
		; Info: EventGhost is listening on home server using AutoRemote through Chrome so i can send links from anywhere.
		AR_TargetKey = %ARkey_homeServer%
		AR_Message := "torrent=:=" . clipboard
		AutoRemoteSend()
	}

AddCommand("AR_Dell_Custom", "AutoRemote send Dell=:= to HomePC")
AR_Dell_Custom()
	{
		InputBox, args, "Dell=:=", , , , 120, , , , , "Enter only the command after =:="
		AR_TargetKey = %ARKey_Main%
		AR_Message := "Dell=:=" . args
		AutoRemoteSend()
	}

AddCommand("AR_Selun_Custom", "AutoRemote send selun=:= to Lenovo")
AR_Selun_Custom()
	{
		InputBox, args, "selun=:=", , , , 120, , , , , "Enter only the command after =:="
		AR_TargetKey = %ARKey_Main%
		AR_Message := "selun=:=" . args
		AutoRemoteSend()
	}

AddCommand("AR_HTC_SendToClipboard", "Send current clipboard content to HTCOne's clipboard.")
AR_HTC_SendToClipboard()
	{
		AR_TargetKey = %AR_i9100_key%
		AR_Message := "clip=:=" . clipboard
		AutoRemoteSend()
	}

;========================================================================================
; Pushover
; Set AR_Target_Key the key to the device you want to send message to
; Set AR_Message the message you want to send
; blahhhhh

AddCommand("PushoverHTC", "Send a Pushover message to my HTCOne")
PushoverHTC()
	{
		JsonURL := PO_PushoverURL
		InputBox, inputmessage, "Message to HTCOne", , , , 120, , , , , "Enter your message"
		JsonMessage := {token : PO_Token, user : PO_User, message : inputmessage, device : PO_Device, title : AHK}
		CurlFormJson()
	}

;========================================================================================
; PushBullet ; variables: PB_Key (api key), PB_PushUrl, PB_Device
; Usually

PushBulletCommon() ; Looks like PushBullet will be used more and more so, creating a common function to set common url, user key and run curl
	{
		JsonURL := PB_PushUrl ; Leave it as it is
		JsonUser := PB_Key ; Main user key, define in Vars
		CurlFormJson()
	}

AddCommand("PushBulletChrome", "Send a PushBullet message to Chrome")
PushBulletChrome()
	{
		PB_Device := PB_Chrome ; change to desired device
		InputBox, inputmessage, "Message to Chrome", , , , 120, , , , , "Enter your message"
		JsonMessage := {"device_iden" : (PB_Device), "type": "note", "title" : "AHK" , "body" : (inputmessage)}
		PushBulletCommon()
	}

AddCommand("PushBulletHTCOne", "Send a PushBullet message to HTC One")
PushBulletHTCOne()
	{
		PB_Device := PB_HTCOne ; change to desired device
		InputBox, inputmessage, "Message to Chrome", , , , 120, , , , , "Enter your message"
		JsonMessage := {"device_iden" : (PB_Device), "type": "note", "title" : "AHK" , "body" : (inputmessage)}
		PushBulletCommon()
	}
