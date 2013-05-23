editor = %A_ProgramFiles%\Vim\vim73\gvim.exe
edit_short = gvim
edit_flags = 

EnvGet, userprofile, USERPROFILE
cfgdir = %userprofile%\.config\text_for_teh_win
tmpdir = %cfgdir%\tmp

ifNotExist, %tmpdir%
    FileCreateDir %tmpdir%

FileGetAttrib, a, %tmpdir%
IfNotInString, a, D
{
    MsgBox %tmpdir% is not a directory.
    ExitApp 1
}

make_tmpfile()
{
    global tmpdir
    FormatTime, fmt_time, , yyyy-MM-dd-HH-mm-ss
    tmpfile = %tmpdir%\%fmt_time%.txt
    ifExist, %tmpfile%
        FileDelete %tmpfile%         ;FIXME check for failure
    FileAppend, , %tmpfile%          ;Make an empty file
    FileSetAttrib, -R, %tmpfile%     ;Make it not read-only
    FileAppend, %Clipboard%, %tmpfile%

    return %tmpfile%
}

edit_tmpfile(tmpfile) 
{
    global editor 
    global edit_flags
    RunWait %editor% %edit_flags% %tmpfile%
    return ErrorLevel
}

read_tmpfile(tmpfile)
{
    Clipboard = 
    FileRead, Clipboard, %tmpfile%
}

#v::
    target_wid := WinExist("A")
    WinGetTitle, target_title, ahk_id %target_wid%
    WinGet, target_proc, ProcessName, ahk_id %target_wid%
    WinGet, target_pid, ID, ahk_id %target_wid%
    WinGetClass, target_class, ahk_id %target_wid%

    ClipSaved := ClipboardAll
    Clipboard = 

    SendInput ^a
    Sleep 100
    SendInput ^c
    Sleep 100
    
    tmpfile := make_tmpfile()

    If edit_tmpfile(tmpfile) == 0
    {
        read_tmpfile(tmpfile)
        WinActivate ahk_id %target_wid%
        Sleep 10
        SendInput ^a
        Sleep 100
        SendInput ^v
        Sleep 100
    }
    else MsgBox Failed to edit %tmpfile%, leaving %target_title% unchanged.

    Clipboard := ClipSaved
    ClipSaved = 

return

#z::
    ExitApp
return
