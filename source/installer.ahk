#include functions.ahk

;get command line flags (silent)

;ask if OK, unless started with silent flag

;figure out if we are installing to 'portable' or normal
;copy config to dest
FileCopyDir, config, %cfgdir%, 1

;copy exe to it's dest

;put up dumb "all done!" flag unlesss started with silent flag

