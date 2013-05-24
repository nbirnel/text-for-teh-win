PROG = tftw

${PROG}.exe :: 
	cd source && make

test :: 
	cygstart ${PROG}.exe

clean ::
	rm -f ${PROG}.exe
	cd source/ && make clean

.PHONY :: clean test

