#!/bin/sh

if [ -z "$LOCALE" ];
then
	LOCALE="en-US"
fi

echo "Scanning & Processing"

tempident="/tmp/ident"
mkdir -p $tempident

#Find all media image files
extensions="jpg jpeg bmp png tiff"
rm /tmp/movethem.sh
for i in $extensions;
do
	find $MOUNTPOINT_SRC -type f -cmin +1 -iname "*.$i" ! -path "*__thumb*" -exec echo -n "mv -n \"{}\" " \; -exec echo -n "$tempident/" \; -exec identify -format %# {} \; -exec bash -c 'echo ".${1##*.}"' _ {} \;  >> /tmp/movethem.sh
done

#move them to the temp directory
sh /tmp/movethem.sh	

cd $tempident
exiftool -r -d $MOUNTPOINT_DST/%Y/%Y-%m/%Y-%m-%d/%Y-%m-%d-%H%M%S_%%f.%%le "-filename<filemodifydate" "-filename<createdate" "-filename<datetimeoriginal" .

#remove all files that already existed
rm -r $tempident
