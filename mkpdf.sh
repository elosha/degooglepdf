#!/bin/bash

#Prerequisites: base64, convert (ImageMagick)
#Also I didn't managed to get the last page, but it's usually the back cover so I didn't lose my sleep for it, i'm sorry

pos=$(pwd)

if [ -z "$1" ]; then
	echo "Usage: $0 [basename]"
	echo "Where \"basename\" is the downloaded PDF datafile's base name without suffix."
	exit 1
fi

echo "Processing file: $1"

mkdir -p "$1"_folder
cd "$1"_folder
mkdir -p pages
cd pages
empt=''
pnghead="data:image/png;base64,"
counter=0

echo "Extracting pages ..."

while read line
do
	if echo "$line" | grep -q $pnghead; then
		if (( counter )); then
			echo "$data_img" | base64 -di - > $counter.png
		fi
		data_img="${line/$pnghead/$empt}"
		let "counter++"
	else
		data_img+=$line$'\n'
	fi
	
done < ../../"$1"

echo "$data_img" > $counter.base64
echo "$data_img" | base64 -di - > $counter.png

echo "Converting to pdf ..."

convert $(ls -1v) ../$1.pdf 
cd $pos

echo "PDF completed!"

