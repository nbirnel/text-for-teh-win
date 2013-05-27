PROG = tftw
INSTALLER = installer
CC = "$$PROGRAMFILES/Autohotkey/Compiler/Ahk2Exe.exe"

${PROG}.exe :: ${PROG}.ahk ${PROG}.ico
	${CC} /in ${PROG}.ahk /icon ${PROG}.ico
	mv $@ ../

${PROG}.ico ::
	cd images && make

${INSTALLER}.exe :: ${INSTALLER}.ahk 
	${CC} /in ${INSTALLER}.ahk
	mv $@ ../

clean ::
	rm -f ${PROG}.exe ${PROG}.ico ${INSTALLER}.exe
	cd images/ && make clean

.PHONY :: clean



