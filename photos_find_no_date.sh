#!/bin/bash 

exiftool \
	-filename \
	-filemodifydate \
	-createdate -r -if '(not $datetimeoriginal) and $filetype eq "JPEG"' .
