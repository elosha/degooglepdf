#!/bin/bash

#Prerequisites: base64, sed, convert (ImageMagick)

PNGHEAD="data:image\/png;base64,"
JPEGHEAD="data:image\/jpeg;base64,"
COUNTER=1
SKIPEXTRACT=0

# Get filename
if [ -z "$1" ]; then
	echo "Usage: $0 input"
	echo "Where \"input\" is the downloaded PDF page archive file name"
	exit 1
fi
if [ ! -f "$1" ]; then
	echo "Error: File $1 does not exist!"
	exit 1
fi

echo "Processing file: $1"

# Base file name without extension/spaces
basename=${1/.imgpack/}
#basename=${basename// /_}
dirname="$basename"_pages

if [ -d "$dirname" ]; then
	read -p "It seems \"${1}\" already has been extracted to \"${dirname}\". Use existing files? (y/n) " yn
	case $yn in
		[yY] ) SKIPEXTRACT=1
			;;
		[nN] ) SKIPEXTRACT=0
			echo "Purging existing files."
			rm -f "$dirname"/*.jpg
			;;
		* ) echo Invalid response
			;;
	esac
else
	mkdir -p "$dirname"
fi

cd "$dirname"

if [ $SKIPEXTRACT == 0 ]; then
	echo -n "Extracting pages: "

	while read line
	do
		echo -n "$COUNTER, "
		padcounter=$(printf "%04d" $COUNTER)
		if echo "$line" | grep -q $PNGHEAD; then
			imgdata=$(echo "$line" | sed -e "s/^$PNGHEAD//")
			echo "$imgdata" | base64 -di - > $padcounter.png
			convert $padcounter.png $padcounter.jpg
			rm $padcounter.png
		fi
		if echo "$line" | grep -q $JPEGHEAD; then
			imgdata=$(echo "$line" | sed -e "s/^$JPEGHEAD//")
			echo "$imgdata" | base64 -di - > $padcounter.jpg
		fi
		let "COUNTER++"
	done < ../"$1"
	echo "done."
fi

# Use ImageMagick to make PDF if available
if command -v convert > /dev/null; then
	echo -n "Generating PDF ..."
	convert $(ls -1v) "../$basename.pdf"
	echo " completed!"
else
	echo "ImageMagick not installed, skipping PDF generation."
fi
cd ..
