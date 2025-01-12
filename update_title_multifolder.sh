#!/bin/bash

# Adds the level 1 folder name in the jpg metadata title and description
# Use: run this schell script in the level 2 folder
# Example:
#   cd ~/Desktop
#   ~/dev/photos_workflow.sh
# Expected: '2020.01.01 Folder Name' is a folder in ~/Desktop.
#           '2020.01.01 Folder Name' has an image file '1.jpg' and '2.jpeg'
#           '1.jpg' and '2.jpeg' will have the folder name in their metadata

# shortcut to rename all in folder

fnc_overwrite() {
    echo "DIRECTORY: $(basename "$d")"
    echo "FILENAME:  $f"
    echo "overwriting title/description"
    exiftool \
        -overwrite_original \
        -XMP:Title="$NEW_TITLE" \
        -EXIF:ImageDescription="$NEW_TITLE" \
        -XMP:Description="$NEW_TITLE" \
        -XMP-dc:Description="$NEW_TITLE" \
        -EXIF:XPTitle="$NEW_TITLE" \
        "$f"

    # display what we've set
    exiftool -f \
        -XMP:Title \
        -EXIF:ImageDescription \
        -XMP:Description \
        -XMP-dc:Description \
        -EXIF:XPTitle \
        "$f"
}

for d in */; do
    shopt -s nullglob
    alloverride="deactivated"
    for f in "$d"*.jp*g "$d"*.png "$d"*.heic; do
        NEW_TITLE="${d%?}"
        OLD_TITLE="$(exiftool -s -s -s -XMP-dc:Description "$f")"

        if [ "$OLD_TITLE" == "" -o "$alloverride" == "active" ]; then
            fnc_overwrite
        elif [ "$OLD_TITLE" != "$NEW_TITLE" ]; then
            echo "DIRECTORY:     $(basename "$d")"
            echo "FILENAME:      $f"
            echo "OVERRIDE:      $alloverride"
            echo "CURRENT TITLE: $OLD_TITLE"
            read -p "Not an empty title, do you want to rename (y/n) or rename ALL inside the folder (a)? " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Aa]$ ]]; then
                alloverride="active"
                fnc_overwrite
            elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "skipping, not overrwriting incorrect title name"
            else
                fnc_overwrite
            fi
        fi
    done
done
