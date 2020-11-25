# To use this makefile for the svg to bmp file conversion you need to
# save the svg on a canvas with the desired dimension (currently only
# 128x296 is supported).

# author: Tomas Stary (2020)

PIXELS128x296=$(echo 128*296| bc -l)
PIXELS400x300=$(echo 400*300| bc -l)
# MEMSIZE128x296=4736

PYTHON=python3

all: bleskomat_128x296.h bleskomat_200x200.h bleskomat_400x300.h

%.bmp: %.svg
	# -depth 8 -type palette truecolor
	convert $< -depth 8 -type truecolor $@

# %_128x296.bin: %_128x296.bmp
# 	xxd -ps $< | tr -d '\n'| tail -c $(PIXELS128x296) | rev | fold -w 296 > $@

%_128x296.txt: %_128x296.bmp size_128x296.py binaryimage.py
	echo 'filename="$<"' | cat $(word 2, $+) - $(word 3, $+) | $(PYTHON) > $@

%_200x200.txt: %_200x200.bmp size_200x200.py binaryimage.py
	echo 'filename="$<"' | cat $(word 2, $+) - $(word 3, $+) | $(PYTHON) > $@

%_400x300.txt: %_400x300.bmp size_400x300.py binaryimage.py
	echo 'filename="$<"' | cat $(word 2, $+) - $(word 3, $+) | $(PYTHON) > $@

%_trans.txt: %.txt transpose.py 
	echo 'filename="$<"' | \
	cat - $(word 2, $+) | \
	$(PYTHON) | \
	rev | \
	perl -e "while(<>){s/(.{8})/0b\$$1, /g;print;}" \
	> $@

%.h: head.hpart %_trans.txt tail.hpart
	echo "const unsigned char $*[] PROGMEM = {" | \
	cat $< - $(word 2, $+) $(word 3, $+) \
	> $@

clean:
	-rm *.bin *.txt *.bmp
