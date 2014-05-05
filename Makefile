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
	rm -f ${PROG}.exe ${INSTALLER}.exe ${LONG}.zip README.txt

clean ::
	rm -f README.html
	cd source/ && make clean

dist :: ${LONG}.zip 

README.txt :: README.html
	lynx -dump $< | u2d > $@

README.html :: README.md
	Markdown.pl $< > $@

${LONG}.zip :: ${PROG}.exe ${INSTALLER}.exe README.txt
	cd .. && \
		zip -r ${LONG}.zip ${LONG}/${PROG}.exe ${LONG}/${INSTALLER}.exe \
		${LONG}/config/ ${LONG}/LICENSE ${LONG}/README.txt ${LONG}/README.html \
		&& mv ${LONG}.zip ${LONG}/ 

push :: ${LONG}.zip
	scp $< noah@www.birnel.org:~/birnel.org/birnel.org/~noah/software/text-for-teh-win

.PHONY :: clean cleanall test install installer dist push

