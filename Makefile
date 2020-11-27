# To use this makefile for the svg to bmp file conversion you need to
# save the svg on a canvas with the desired dimension.

# author: Tomas Stary (2020)

PYTHON=python3

all: bleskomat_128x296.h bleskomat_200x200.h bleskomat_400x300.h

%.bmp: %.svg
	# -depth 8 -type palette truecolor
	convert $< -depth 8 -type truecolor $@

bleskomat_%.text: bleskomat_%.bmp size_%.py binaryimage.py
	echo 'filename="$<"' | cat $(word 2, $+) - $(word 3, $+) | $(PYTHON) > $@

%_trans.txt: %.text transpose.py 
	echo 'filename="$<"' | \
	cat - $(word 2, $+) | \
	$(PYTHON) | \
	rev | \
	awk '{printf "%s", $$0; next}' |\
	sed -e "s@\\n@@g" |\
	perl -e "while(<>){s/(.{8})/0b\$$1, /g;print;}" \
	> $@

%.h: head.hpart %_trans.txt tail.hpart
	echo "const unsigned char $*[] PROGMEM = {" | \
	cat $< - $(word 2, $+) $(word 3, $+) \
	> $@

clean:
	-rm *.bin *.text *.bmp
