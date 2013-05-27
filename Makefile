PROG = tftw
INSTALLER = installer

${PROG}.exe :: 
	cd source && make

${INSTALLER}.exe :: 
	cd source && make $@

test :: 
	cygstart ${PROG}.exe

clean ::
	rm -f ${PROG}.exe ${INSTALLER}.exe 
	cd source/ && make clean

.PHONY :: clean test


