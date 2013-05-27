editor = %A_ProgramFiles%\Vim\vim73\gvim.exe
edit_short = gvim
edit_flags = 

#include functions.ahk

tmpdir = %cfgdir%\tmp
cfg = %cfgdir%\config.ini

make_dir(tmpdir)

If FileExist(cfg)
{
    Loop, read, %cfg%
    {
        parse_ini("editor", A_LoopReadLine)
        parse_ini("edit_short", A_LoopReadLine) 
    }
}

edit_dir = %cfgdir%\editors\%edit_short%
edit_dir_class = %edit_dir%\class
edit_dir_proc = %edit_dir%\proc
edit_dir_title = %edit_dir%\title
sourceflagf = %edit_dir%\sourceflag.ini
make_dir(edit_dir)
make_dir(edit_dir_class)
make_dir(edit_dir_proc)
make_dir(edit_dir_title)

global_editor_config()

parse_ini(var, line)
{
    global
    lenvar := StrLen(var)
    i_eq  := lenvar+1
    i_val := i_eq+1
    vareq = %var%=

    If (SubStr(line, 1, i_eq) = vareq) 
    {
        val := SubStr(line, i_val)
        %var% = %val%
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

global_editor_config()
{
    global
    Loop, read, %sourceflagf%
    {
        parse_ini("sourceflag", A_LoopReadLine)
        parse_ini("extension", A_LoopReadLine)
    }
}

load_edit_configs(type)
{
    global edit_flags
    global sourceflag
    global extension
    global edit_dir
    global class
    global title
    global proc
    dotext := "." . extension
    type_dir = %edit_dir%\%type%\*
    Loop, %type_dir%
    {
        basename := RegExReplace(A_LoopFileName, dotext)
        IfInString, %type%, %basename%
            If A_LoopFileExt = %extension%
                edit_flags = %edit_flags% %sourceflag% `"%A_LoopFileLongPath%`"
    }
}

editor_config()
{
    global
    load_edit_configs("class")
    load_edit_configs("proc")
    load_edit_configs("title")
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

select_line()
{
    Sleep 100
    SendInput {HOME}
    SendInput +{END}
    Sleep 100
}

select_all()
{
    Sleep 100
    SendInput ^{HOME}
    SendInput ^+{END}
    Sleep 100
}

get_text()
{
    select_all()
    SendInput ^c
    Sleep 100
}

send_text()
{
    select_all()
    SendInput ^v
    Sleep 100
}

#v::
    target_wid := WinExist("A")
    WinGetTitle, title, ahk_id %target_wid%
    WinGet, proc, ProcessName, ahk_id %target_wid%
    WinGet, pid, ID, ahk_id %target_wid%
    WinGetClass, class, ahk_id %target_wid%

    ClipSaved := ClipboardAll
    Clipboard = 

    get_text()
    tmpfile := make_tmpfile()

    editor_config()

    If edit_tmpfile(tmpfile) == 0
    {
        read_tmpfile(tmpfile)
        WinActivate ahk_id %target_wid%
        WinWaitActive, ahk_id %target_wid%, ,3
        if ErrorLevel
            fail(1, "Couldn't activate target.")
        send_text()
    }
    else fail(2, "Failed to edit tempfile, leaving target unchanged.")

    Clipboard := ClipSaved
    ClipSaved = 

return

#z::
    ExitApp
return
