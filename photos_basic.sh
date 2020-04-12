#!/bin/bash
 
# determine current values
IMAGE_TITLE=$(exiftool -s3 -XMP:Title "$1")
 
# Ask user for new values
read -e -p "Title [$IMAGE_TITLE]: " NEW_TITLE
 
# set to defaults if we got a blank result
NEW_TITLE="${NEW_TITLE:-${IMAGE_TITLE}}"
 
# Update
exiftool \
    -overwrite_original \
    -XMP:Title="$NEW_TITLE" \
    -EXIF:ImageDescription="$NEW_TITLE" \
    -IPTC:Caption-Abstract="$NEW_TITLE" \
    -XMP:Description="$NEW_TITLE" \
    -EXIF:XPTitle="$NEW_TITLE" \
    "$1"
 
 
# display what we've set
exiftool -f \
    -XMP:Title \
    -EXIF:ImageDescription \
    -IPTC:Caption-Abstract \
    -XMP:Description \
    -EXIF:XPTitle \
    "$1"
