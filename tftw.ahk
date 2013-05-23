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
    target_id := WinExist("A")
    WinGetTitle, target_name, ahk_id %target_id%

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
        WinActivate ahk_id %target_id%
        Sleep 10
        SendInput ^a
        Sleep 100
        SendInput ^v
        Sleep 100
    }
    else MsgBox Failed to edit %tmpfile%, leaving %target_name% unchanged.

    Clipboard := ClipSaved
    ClipSaved = 

return

#z::
    ExitApp
return