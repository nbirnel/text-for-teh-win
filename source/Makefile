PROG = tftw
CC = "$$PROGRAMFILES/Autohotkey/Compiler/Ahk2Exe.exe"

${PROG}.exe :: ${PROG}.ahk ${PROG}.ico
	${CC} /in ${PROG}.ahk /icon ${PROG}.ico
	mv $@ ../

${PROG}.ico ::
	cd images && make

clean ::
	rm -f ${PROG}.exe ${PROG}.ico
	cd images/ && make clean

.PHONY :: clean



