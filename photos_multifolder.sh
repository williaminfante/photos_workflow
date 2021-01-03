#!/bin/bash

# Adds the level 1 folder name in the jpg metadata title and description
# Use: run this schell script in the level 2 folder
# Example:
#   cd ~/Desktop
#   ~/dev/photos_workflow.sh
# Expected: '2020.01.01 Folder Name' is a folder in ~/Desktop.
#           '2020.01.01 Folder Name' has an image file '1.jpg' and '2.jpeg'
#           '1.jpg' and '2.jpeg' will have the folder name in their metadata

fnc_overwrite() {
    echo "DIRECTORY: $(basename "$d")"
    echo "FILENAME: $f"
    echo "overwriting title/description"
    exiftool \
        -overwrite_original \
        -XMP:Title="$NEW_TITLE" \
        -EXIF:ImageDescription="$NEW_TITLE" \
        -XMP:Description="$NEW_TITLE" \
        -EXIF:XPTitle="$NEW_TITLE" \
        "$f"

    # display what we've set
    exiftool -f \
        -XMP:Title \
        -EXIF:ImageDescription \
        -XMP:Description \
        -EXIF:XPTitle \
        "$f"
}

for d in */; do
    shopt -s nullglob
    for f in "$d"*.jp*g "$d"*.png; do
        NEW_TITLE="${d%?}"
        OLD_TITLE="$(exiftool -s -s -s -EXIF:ImageDescription "$f")"

        if [ "$OLD_TITLE" == "" ]; then
            fnc_overwrite
        elif [ "$OLD_TITLE" != "$NEW_TITLE" ]; then
            echo "DIRECTORY:     $(basename "$d")"
            echo "FILENAME:      $f"
            echo "CURRENT TITLE: $OLD_TITLE"
            read -p "Not an empty title, do you want to rename? " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "skipping, not overrwriting incorrect title name"
            else
                fnc_overwrite
            fi
        fi
    done
done
