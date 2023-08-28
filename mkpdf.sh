#!/bin/bash

#Prerequisites: base64, sed, convert (ImageMagick)
#Also I didn't managed to get the last page, but it's usually the back cover so I didn't lose my sleep for it, i'm sorry

if [ ! -f "$1" ]; then
	echo "Usage: $0 [basename]"
	echo "Where \"basename\" is the downloaded PDF page archive's file name"
	exit 1
fi

echo "Processing file: $1"

mkdir -p "$1"_pages
cd "$1"_pages
PNGHEAD="data:image\/png;base64,"
COUNTER=1

echo -n "Extracting pages: "

while read line
do
	if echo "$line" | grep -q $PNGHEAD; then
		echo -n "$COUNTER, "
		padcounter=$(printf "%04d" $COUNTER)
		imgdata=$(echo "$line" | sed -e "s/^$PNGHEAD//")
		echo "$imgdata" | base64 -di - > $padcounter.png
		convert $padcounter.png $padcounter.jpg
		rm $padcounter.png
		let "COUNTER++"
	fi
done < ../"$1"
echo "done."

echo -n "Converting to pdf ..."
convert $(ls -1v *.jpg) ../$1.pdf
cd ..

echo " completed!"
