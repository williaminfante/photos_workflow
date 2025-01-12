#!/bin/bash

show_info() {
    echo "VALID folder:               $(basename "$d")"
    echo "Suggested Date from Folder: $my_date"
    echo "Directory and filename:     $f"
    echo "Date in Photo:              $date_of_file"
}

for d in */; do
    # Extract date from folder name (YYYY.MM.DD format)
    my_date=$(echo "$d" | grep -oE '^[0-9]{4}\.[0-9]{2}\.[0-9]{2}')

    # Skip folders with a dash (-) immediately after the date
    if [[ "$d" =~ ^[0-9]{4}\.[0-9]{2}\.[0-9]{2}- ]]; then
        echo "Skipping folder with dash after date: $d"
        continue
    fi

    if [[ -z "$my_date" ]]; then
        echo "Invalid folder name format: $d"
        continue
    fi

    # Check if the folder name matches the expected pattern
    if [[ "$my_date" =~ ^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$ ]]; then
        shopt -s nullglob
        for f in "$d"*.jp*g "$d"*.png; do
            # Get existing DateTimeOriginal tag value
            date_of_file="$(exiftool -p '$DateTimeOriginal' -d %Y.%m.%d "$f" -q -q)"
            if [ -z "$date_of_file" ]; then
                # Show info and set DateTimeOriginal if it doesn't exist
                show_info
                echo "Setting DateTimeOriginal for $f"
                exiftool "-DateTimeOriginal=${my_date//./:} 00:00:00" -overwrite_original "$f"
            elif [ "$my_date" != "$date_of_file" ]; then
                # Show info and prompt user to fix mismatched dates
                show_info
                read -p "Dates not matching. Change? (y/n) or skip all in folder (l): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Ll]$ ]]; then
                    echo "Skipping ALL INSIDE the FOLDER"
                    break
                elif [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo "Updating DateTimeOriginal for $f"
                    exiftool "-DateTimeOriginal=${my_date//./:} 00:00:00" -overwrite_original "$f"
                else
                    echo "No changes to this file"
                fi
            fi
        done
    else
        echo "Folder date pattern mismatch: $d"
    fi
done
