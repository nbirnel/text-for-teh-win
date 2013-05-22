editor = %A_ProgramFiles%\Vim\vim73\gvim.exe
edit_flags = 

EnvGet, userprofile, USERPROFILE
tmpdir = %userprofile%\.config\text_for_teh_win

ifNotExist, %tmpdir%
    FileCreateDir %tmpdir%

FileGetAttrib, a, %tmpdir%
IfNotInString, a, D
{
    MsgBox %tmpdir% is not a directory.
    ExitApp 1
}

edit_tmpfile(tmpfile) 
{
    global editor 
    global edit_flags
    RunWait %editor% %edit_flags% %tmpfile%
    return ErrorLevel
}

make_tmpfile()
{
    global tmpdir
    tmpfile = %tmpdir%\%A_Now%.txt
    ifExist, %tmpfile%
        FileDelete %tmpfile%         ;FIXME check for failure
    FileAppend, , %tmpfile%          ;Make an empty file
    FileSetAttrib, -R, %tmpfile%     ;Make it not read-only
    FileAppend, %Clipboard%, %tmpfile%

    return %tmpfile%
}

save_clip()
{
}

restore_clip()
{
}


#v::
    target_id := WinExist("A")
    WinGetTitle, target_name, ahk_id %target_id%

    save_clip()

    SendInput ^a^c
    
    tmpfile := make_tmpfile()

    If edit_tmpfile(tmpfile) == 0
    {
        WinActivate ahk_id %target_id%
        Sleep 10
        SendInput ^a^v
    }
    else MsgBox Failed to edit %tmpfile%, leaving %target_name% unchanged.

    restore_clip()

return

#z::
    ExitApp
return
