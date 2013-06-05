editor = %A_Windir%\system32\notepad.exe
short_name = np
edit_flags_base =
sourceflag =
extension =

#include functions.ahk
make_menu()
initialize()

make_menu() {
    Menu, TRAY, NoStandard
    Menu, TRAY, add, Text For Teh Win &help, help
    Menu, TRAY, add,
    Menu, TRAY, add, &Cancel next paste, aborter
    Menu, TRAY, add,
    Menu, TRAY, add, Browse &temporary files, browse_tmpfiles
    Menu, TRAY, add,
    Menu, TRAY, add, &Edit configuration, edit_config
    Menu, TRAY, add, &Reload configuration, reloader
    Menu, TRAY, add, &Browse configurations, browse_config
    Menu, TRAY, add, &Select configuration, select_config
    Menu, TRAY, add, Restore &default configuration, default_config
    Menu, TRAY, add,
    Menu, TRAY, add, E&xit, self_destruct
}

initialize() {
    global
    edit_flags = 

    tmpdir = %cfgdir%\tmp
    cfg = %cfgdir%\config.ini

    make_dir(tmpdir)

    If FileExist(cfg)
    {
        IniRead, short_name, %cfg%, editor, short_name, %A_Space%

        IniRead, editor,          %cfg%, editor_%short_name%, editor, %A_Space%
        IniRead, sourceflag,      %cfg%, editor_%short_name%, sourceflag, %A_Space%
        IniRead, edit_flags_base, %cfg%, editor_%short_name%, edit_flags_base, %A_Space%
        IniRead, extension,       %cfg%, editor_%short_name%, extension, %A_Space%
    }

    edit_dir = %cfgdir%\editors\%short_name%
    edit_dir_class = %edit_dir%\class
    edit_dir_proc = %edit_dir%\proc
    edit_dir_title = %edit_dir%\title
    make_dir(edit_dir)
    make_dir(edit_dir_class)
    make_dir(edit_dir_proc)
    make_dir(edit_dir_title)

    global_editor_config()
}

reloadme()
{
    reload
    Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
    die(8, "Reload was unsuccessful after 1 second. I am crashing now.")
    return  ; This should never happen
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
    Loop, %edit_dir%\tftw.%extension%
    {
        edit_flags_base = %edit_flags_base% %sourceflag% `"%A_LoopFileLongPath%`"
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

local_editor_config()
{
    global
    edit_flags = %edit_flags_base%
    load_edit_configs("class")
    load_edit_configs("proc")
    load_edit_configs("title")
}

backup_config()
{
    global cfgdir
    global cfg
    FormatTime, fmt_time, , yyyy-MM-dd-HH-mm-ss
    FileCopy, %cfg%, %cfgdir%\config-%fmt_time%.ini, 1
    err = %ErrorLevel%
    if err != 0
        fail(8, "Couldn't create backup configuration")
    return %err%
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
    SendInput ^{INSERT}
    Sleep 100
}

send_text()
{
    select_all()
    SendInput +{INSERT}
    Sleep 100
    SendInput ^{HOME}
    ; FIXME the ^ here and in select all should be factored out as 'linewise'
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

    local_editor_config()

    If edit_tmpfile(tmpfile) == 0
    {
        if abort
            abort = 
        else
        {
            read_tmpfile(tmpfile)
            WinActivate ahk_id %target_wid%
            WinWaitActive, ahk_id %target_wid%, ,3
            if ErrorLevel
                fail(1, "Couldn't activate target.")
            send_text()
        }
    }
    else fail(2, "Failed to edit tempfile, leaving target unchanged.")

    Clipboard := ClipSaved
    ClipSaved = 

return

#+v:: abort = 1

#z::
    ExitApp
return

self_destruct:
ExitApp
return

aborter:
abort = 1
return

browse_tmpfiles:
Run, %tmpdir%
return

browse_config:
Run, %cfgdir%
return

select_config:
;File and path must exist
FileSelectFile, newcfg, 3, %cfgdir%, "Select a configuration", Ini Files(*.ini)
if ErrorLevel
    return
if backup_config() != 0
    return
FileCopy, %newcfg%, %cfg%, 1
if ErrorLevel
    fail(8, "Couldn't switch onfiguration")
reloadme()
return

edit_config:
if backup_config() != 0
    return
RunWait %editor% %edit_flags% %cfg%
reloadme()
return

; KEEP DEFAULT_CONFIG: AND RELOADER: TOGETHER; see next comment.
default_config:
if backup_config() != 0
    return
FileCopy, %cfgdir%\default.ini, %cfg%, 1
if ErrorLevel
    fail(7, "Couldn't restore default configuration")
; Lack of return here is deliberate - we are falling through to reloader

reloader:
reloadme()
return  ; This should never happen

help:
helpmsg = 
(
Windows-v to edit current panel in your text editor.
Windows-Shift-v to cancel pasting that text back to it's origin.
Windows-z to close this application.
)
MsgBox %helpmsg%
return

