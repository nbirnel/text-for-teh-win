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
        fail(3, errmsg)
    }
}

