#!/bin/bash
echo "$1"
echo "$2"
exiftool \
	-datetimeoriginal="$1 12:00:00"\
	"$2"
