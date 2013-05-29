EnvGet, userprofile, USERPROFILE
cfgdir = %userprofile%\.config\text_for_teh_win

make_dir(dir)
{
    ifNotExist, %dir%
        FileCreateDir %dir%

    FileGetAttrib, a, %dir%
    IfNotInString, a, D
    {
        errmsg =  %dir% is not a directory.
        die(3, errmsg)
    }
}

fail(err, msg)
{
    global tmpfile
    global title
    global edit_flags
    MsgBox, Error: %err% `nEdit flags: %edit_flags% `nTempfile: %tmpfile%`nTarget: %title%`n%msg%
}

die(err, msg)
{
    global tmpfile
    global title
    MsgBox, Error: %err% `nTempfile: %tmpfile%`nTarget: %title%`n%msg%
    ExitApp %err%
}

