#!/bin/bash 

# Find images with no creation dates (including subfolders)
exiftool \
	-filename \
	-filemodifydate \
	-createdate -r -if '(not $datetimeoriginal) and $filetype eq "JPEG"' .
