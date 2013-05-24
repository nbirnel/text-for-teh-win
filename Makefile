PROG = tftw
CC = "$$PROGRAMFILES/Autohotkey/Compiler/Ahk2Exe.exe"

${PROG}.exe :: source/${PROG}.ahk
	cd source && ${CC} /in $< && mv $@ ./

test :: 
	cygstart source/${PROG}.ahk
