;#Include %A_ScriptDir%\Functions_Home.ahk

; Control key  ^
; Alt key      !
; Shift key    +
; Windows key  # 

;connect to vpn
^+v::
	{
		Run, Rasdial vpn_name user pass
	}
	
; uTorrent copy url into clipboard then add that torrent remotely
^!m::run, http://%UTORUSER%:%UTORPASS%@%uTorrentIP%:%uTorrentPort%/gui/?action=add-url&s=%Clipboard%

; Open remote utorrent using Web UI
^!u::run, http://%UTORUSER%:%UTORPASS%@%uTorrentIP%:%uTorrentPort%/gui/


; PSEXEC Connect to VPN on a remote computer
^!v::
	ConnectVPNRemote()
	return
	
; PSEXEC Open a inputbox with a cmd to run on a remote machine
^!r::
	PSexecWArgs()
	return