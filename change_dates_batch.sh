#!/bin/bash

show_info() {
    echo "VALID folder:               $(basename "$d")"
    echo "Suggested Date from Folder: $my_date"
    echo "Directory and filename:     $f"
    echo "Date in Photo:              $date_of_file"
}

for d in */; do
    my_date=$(echo "$d" | head -c10)
    is_matching=$([[ $my_date =~ ^[0-9]{4}\.(0[1-9]|1[0-2])\.(0[1-9]|[1-2][0-9]|3[0-1])$ ]] && echo "matched" || echo "did not match")

    if [ "$is_matching" == "matched" ]; then
        shopt -s nullglob

        for f in "$d"*.jp*g "$d"*.png; do
            date_of_file="$(exiftool -p '$DateTimeOriginal' -d %Y.%m.%d "$f" -q -q)"
            if [ "$date_of_file" == "" ]; then
                show_info
                exiftool '-datetimeoriginal<${directory;s/.*(\d{4})-(\d\d)-(\d\d).*/$1:$2:$3/} 00:00:00' -if '(not $datetimeoriginal)'  "$f"
            elif [ "$my_date" != "$date_of_file" ]; then
                show_info
                read -p "Dates not matching. Change? (y/n) or skip all in folder (l): " -n 1 -r
                echo
                    if [[ $REPLY =~ ^[Ll]$ ]]; then
                        echo "skipping ALL INSIDE the FOLDER"
                        break;
                    elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
                        echo "no changes to this file"
                    else
                       exiftool '-datetimeoriginal<${directory;s/.*(\d{4})-(\d\d)-(\d\d).*/$1:$2:$3/} 00:00:00' -if '${directory;$_=substr($_,0, 11);s/\.//;s/\.//;s/.*(\d{4})-(\d\d)-(\d\d).*/$1$2$3" "/} ne $datetimeoriginal' -d '%Y%m%d '  "$f"
                fi
            fi
        done
    fi
done
