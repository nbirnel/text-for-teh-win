; edit in Vim...
#v::
WinGetActiveTitle, VimTargetWindow
SendInput ^a^c
RunWait c:\Program Files (x86)\Vim\vim73\gvim.exe --servername ClipBrd +ClipBrd +only
If not ErrorLevel
{
    WinActivate %VimTargetWindow%
    Sleep 10
    SendInput ^a^v
}
return
