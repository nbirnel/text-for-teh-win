PROG = tftw
CC = "$$PROGRAMFILES/Autohotkey/Compiler/Ahk2Exe.exe"

${PROG}.exe :: src/${PROG}.ahk
	${CC} /in $< && mv src/$@ ./

test :: 
	cygstart src/${PROG}.ahk
