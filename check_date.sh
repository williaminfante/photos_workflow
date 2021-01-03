#!/bin/bash



for d in */; do
    my_date=$(echo "$d" | head -c10)
    is_matching=$([[ $my_date =~ ^[0-9]{4}\.(0[1-9]|1[0-2])\.(0[1-9]|[1-2][0-9]|3[0-1])$ ]] && echo "matched" || echo "did not match")

    if [ "$is_matching" == "matched" ]; then
        echo "Going inside the valid folder: $(basename "$d")"
        shopt -s nullglob

        for f in "$d"*.jp*g "$d"*.png; do
            date_of_file="$(exiftool -p '$DateTimeOriginal' -d %Y.%m.%d "$f")"
            full_date="$(exiftool -p '$DateTimeOriginal' -d %Y.%m.%d____%H:%M:%S "$f")"
            if [ "$my_date" != "$date_of_file" ]; then
                echo "Suggested Date from Folder: $my_date"
                echo "Directory and filename:     $f"
                echo "Date in Photo:              $full_date"
                read -p "Date in filename does not match folder suggested, do you want to change? y/n (or press l to skip all in subfolder): " -n 1 -r
                echo
                    if [[ $REPLY =~ ^[Ll]$ ]]; then
                        echo "skipping ALL INSIDE FOLDER, not overrwriting incorrect date"
                        break;
                    elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
                        echo "skipping, not overrwriting incorrect date"
                    else
                       exiftool '-datetimeoriginal<${directory;s/.*(\d{4})-(\d\d)-(\d\d).*/$1:$2:$3/} 00:00:00' -if '(not $datetimeoriginal) or (${directory;$_=substr($_,0, 11);s/\.//;s/\.//;s/.*(\d{4})-(\d\d)-(\d\d).*/$1$2$3" "/} ne $datetimeoriginal)' -d '%Y%m%d '  "$f"
                fi
            fi
        done
    fi
done


# expansion -> check date ranges not to include them
# once we know the folder is wrong, have the option to skip all photos in that subfolder