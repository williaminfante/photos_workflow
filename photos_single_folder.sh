        for f in *.jpg; do
            echo "$f"
            NEW_TITLE="${PWD##*/}"
            #NEW_TITLE="${d%?}"

            # Update
            exiftool \
                -overwrite_original \
                -XMP:Title="$NEW_TITLE" \
                -EXIF:ImageDescription="$NEW_TITLE" \
                -IPTC:Caption-Abstract="$NEW_TITLE" \
                -XMP:Description="$NEW_TITLE" \
                -EXIF:XPTitle="$NEW_TITLE" \
                "$f"

            # display what we've set
            exiftool -f \
                -XMP:Title \
                -EXIF:ImageDescription \
                -IPTC:Caption-Abstract \
                -XMP:Description \
                -EXIF:XPTitle \
                "$f"
     done 
