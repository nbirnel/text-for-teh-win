#include functions.ahk

dest = %userprofile%\Desktop

;get command line flags (silent)

;ask if OK, unless started with silent flag
MsgBox, 1, Text-for-teh-win installer, Installing config files to %cfgdir%,`nand executable to %dest%\ttfw.exe
IfMsgBox, Cancel
    ExitApp, 6

;figure out if we are installing to 'portable' or normal

;copy config to dest
FileCopyDir, config, %cfgdir%, 1
if ErrorLevel
    die(4, "Failed to install configuration directory")

;copy exe to it's dest
FileCopy, tftw.exe, %dest%, 1
if ErrorLevel
    die(5, "Failed to install")

;put up dumb "all done!" message unlesss started with silent flag
MsgBox, Installed config files in %cfgdir%,`nand executable at %dest%\ttfw.exe


