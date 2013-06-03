PROG = tftw
INSTALLER = install

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
dist ::
	zip -r textpad-eed-syntax.zip textpad/INSTALL.txt textpad/config \
	textpad/screenshots textpad/install.exe textpad/src/*.syn

push ::
	scp textpad-eed-syntax.zip noah@www.birnel.org:~/birnel.org/birnel.org/~noah/software/textpad-eed-syntax
