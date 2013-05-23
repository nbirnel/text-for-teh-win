editor = %A_ProgramFiles%\Vim\vim73\gvim.exe
edit_short = gvim
edit_flags = 

EnvGet, userprofile, USERPROFILE
cfgdir = %userprofile%\.config\text_for_teh_win
tmpdir = %cfgdir%\tmp
cfg = %cfgdir%\config.ini

make_dir(tmpdir)

If FileExist(cfg)
{
    Loop, read, %cfg%
    {
        If (SubStr(A_LoopReadLine, 1, 7) = "editor=") 
        {
            val := SubStr(A_LoopReadLine, 8)
            editor = %val%
        }
        If (SubStr(A_LoopReadLine, 1, 11) = "edit_short=") 
        {
            val := SubStr(A_LoopReadLine, 12)
            edit_short = %val%
        }
    }
}

editdir = %cfgdir%\editors\%edit_short%
edit_classdir = %editdir%\class
edit_procdir = %editdir%\proc
edit_titledir = %editdir%\title
make_dir(editdir)
make_dir(edit_classdir)
make_dir(edit_procdir)
make_dir(edit_titledir)

make_dir(dir)
{
    ifNotExist, %dir%
        FileCreateDir %dir%

    FileGetAttrib, a, %dir%
    IfNotInString, a, D
    {
        errmsg =  %dir% is not a directory.
        fail(3, errmsg)
    }
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

fail(err, msg)
{
    global tmpfile
    global target_title
    MsgBox, Error: %err% `nTempfile: %tmpfile%`nTarget: %target_title%`n%msg%
    ExitApp %err%
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
        WinWaitActive, ahk_id %target_wid%, ,3
        if ErrorLevel
            fail(1, "Couldn't activate target.")
        Sleep 100
        SendInput ^a
        Sleep 100
        SendInput ^v
        Sleep 100
    }
    else fail(2, "Failed to edit tempfile, leaving target unchanged.")

    Clipboard := ClipSaved
    ClipSaved = 

return

#z::
    ExitApp
return
