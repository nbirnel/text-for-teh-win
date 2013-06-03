PROG = tftw
LONG = text-for-teh-win
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
	rm -f ${PROG}.exe ${INSTALLER}.exe ${LONG}.zip

clean ::
	cd source/ && make clean

dist :: ${LONG}.zip 

${LONG}.zip :: ${PROG}.exe ${INSTALLER}.exe
	cd .. && zip -r ${LONG}.zip ${LONG}/${PROG}.exe ${LONG}/${INSTALLER}.exe \
		${LONG}/config/ ${LONG}/LICENSE && mv ${LONG}.zip ${LONG}/

push :: ${LONG}.zip
	scp $< noah@www.birnel.org:~/birnel.org/birnel.org/~noah/software/text-for-teh-win

.PHONY :: clean cleanall test install installer dist push

