#!/bin/bash

# shortcut to rename file in folder
# use: rename_to_description.sh <folder>

echo "value $1"
exiftool '-Filename<$XMP:Title%-c.$FileTypeExtension' "$1"
