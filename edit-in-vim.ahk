; edit in Vim...
#v::
vim = %A_ProgramFiles%\Vim\vim73\gvim.exe
;WinGetActiveTitle, TargetWindow
TargetWindow := WinExist("A")
MsgBox Target Window's HWND is %TargetWindow%
exit
SendInput ^a^c
; RunWait %vim% --servername ClipBrd +ClipBrd +only
RunWait %vim% --servername ClipBrd 
RunWait %vim% --servername ClipBrd --remote-send '"*p'
If not ErrorLevel
{
    WinActivate %TargetWindow%
    Sleep 10
    SendInput ^a^v
}
return

