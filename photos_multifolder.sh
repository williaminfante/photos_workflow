# Adds the level 1 folder name in the jpg metadata title and description
# Use: run this schell script in the level 2 folder
# Example:
#   cd ~/Desktop
#   ~/dev/photos_workflow.sh
# Expected: '2020.01.01 Folder Name' is a folder in ~/Desktop.
#           '2020.01.01 Folder Name' has an image file '1.jpg' and '2.jpg'
#           '1.jpg' and '2.jpg' will have the folder name in their metadata

for d in */; do
    echo $d 
        for f in "$d"*.jpg; do
            echo "$f"
            echo $(basename "$d")
            #NEW_TITLE="${PWD##*/}"
            NEW_TITLE="${d%?}"

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
done
