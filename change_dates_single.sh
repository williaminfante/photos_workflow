#!/bin/bash

# Modifies the date of the image file
# Use ~/dev/photos_workflow/photos_change_date_basic.sh 2020.12.31 'path/image.jpg'

echo "$1"
echo "$2"
exiftool \
	-datetimeoriginal="$1 12:00:00"\
	"$2"
