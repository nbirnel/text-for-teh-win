#include functions.ahk

dest = %userprofile%\Desktop

;get command line flags (silent)


Gui, Add, Text, , Installing config files to %cfgdir%
Gui, Add, Text, , and executable to %dest%\ttfw.exe
Gui, Add, Button, default, &OK
Gui, Add, Button,, &Cancel
Gui, Add, Checkbox, vSelectInstall, Choose Installation &Directory?
Gui, Show,,   Text-for-teh-win installer,


ButtonCancel:
ExitApp

ButtonOK:
Gui, Submit
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

