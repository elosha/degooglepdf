#!/bin/bash

#Prerequisites: base64, convert (ImageMagick)
#Also I didn't managed to get the last page, but it's usually the back cover so I didn't lose my sleep for it, i'm sorry

if [ ! -f "$1" ]; then
	echo "Usage: $0 [basename]"
	echo "Where \"basename\" is the downloaded PDF page archive's file name"
	exit 1
fi

echo "Processing file: $1"

mkdir -p "$1"_pages
cd "$1"_pages
PNGHEAD="data:image/png;base64,"
COUNTER=0

#echo "Extracting pages ..."

while read line
do
	if echo "$line" | grep -q $PNGHEAD; then
		#echo "$COUNTER PNG header found."
		if (( COUNTER )); then
			#echo "$COUNTER Decoding Data."
			echo "$data_img" | base64 -di - > $COUNTER.png
			#echo "$COUNTER Data decoded."
		fi
		#echo "$COUNTER Removing header."
		#FIXME: Hangs on Mac OS with 100% CPU
		data_img="${line/$PNGHEAD/}"
		#echo "$COUNTER Data set."
		let "COUNTER++"
	else
		#echo "$COUNTER One more line ..."
		data_img+=$line$'\n'
	fi
done < ../"$1"

# Save last data
echo "$data_img" | base64 -di - > $COUNTER.png

echo "Converting to pdf ..."
convert $(ls -1v) ../$1.pdf 
cd ..

echo "PDF completed!"
