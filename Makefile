PROG = tftw
CC = "$$PROGRAMFILES/Autohotkey/Compiler/Ahk2Exe.exe"

${PROG}.exe :: source/${PROG}.ahk
	${CC} /in $< && mv source/$@ ./

test :: 
	cygstart source/${PROG}.ahk
