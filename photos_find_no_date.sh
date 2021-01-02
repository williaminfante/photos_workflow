#!/bin/bash 


# Find images with original dates but not the same as the name of the folder

# Find images with no creation dates (including subfolders)
exiftool \
	-filename \
	-filemodifydate \
	-createdate -r -if '(not $datetimeoriginal) and $filetype eq "JPEG"' .
