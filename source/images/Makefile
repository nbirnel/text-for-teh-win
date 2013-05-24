PROG = tftw

${PROG}.ico :: ${PROG}.xcf
	convert $< $@
	mv $@ ../

${PROG}.png :: ${PROG}.xcf
	convert $< $@

clean ::
	rm -f ${PROG}.png ${PROG}.ico

.PHONY :: clean


