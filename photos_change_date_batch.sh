#!/bin/bash

# Go to each subfolder and get string of the name

# Check if the string names has DDDD.DD.DD<space>, if valid cycle

# Check date of each image, and check if it matches the item in the, if not prompt the change

# Y/N to change the date or not

# Modifies the date of the image file
# Use ~/dev/photos_workflow/photos_change_date_basic.sh 2020.12.31 'path/image.jpg'

echo "$1"
echo "$2"
exiftool \
	-datetimeoriginal="$1 12:00:00"\
	$2
