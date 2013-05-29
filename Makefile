PROG = tftw
INSTALLER = installer

install :: ${PROG}.exe ${INSTALLER}.exe
	cygstart ./${INSTALLER}.exe

installer :: ${INSTALLER}.exe

${PROG}.exe :: 
	cd source && make

${INSTALLER}.exe :: 
	cd source && make $@

test :: 
	cygstart ${PROG}.exe

cleanall :: clean
	rm -f ${PROG}.exe ${INSTALLER}.exe 

clean ::
	cd source/ && make clean

.PHONY :: clean cleanall test install installer
