#!/bin/bash

#Prerequisites: base64, sed, convert (ImageMagick)
#Also I didn't managed to get the last page, but it's usually the back cover so I didn't lose my sleep for it, i'm sorry

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
basename=${basename/ /_}

mkdir -p "$basename"_pages
cd "$basename"_pages
PNGHEAD="data:image\/png;base64,"
JPEGHEAD="data:image\/jpeg;base64,"
COUNTER=1

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

echo -n "Converting to pdf ..."
convert $(ls -1v) "../$basename.pdf"
cd ..

echo " completed!"
