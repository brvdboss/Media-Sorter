#!/bin/sh

if [ -z "$LOCALE" ];
then
	LOCALE="en-US"
fi

echo "Scanning & Processing videos"

tempident="/tmp/ident"
mkdir -p $tempident

#Find all media image files
extensions="jpg jpeg bmp png tiff"
rm /tmp/movethem.sh
rm /tmp/batch
for i in $extensions;
do
	find $MOUNTPOINT_SRC -type f -cmin +1 -iname "*.$i" ! -path "*__thumb*" | head -n 10 >> /tmp/batch
done

while read line
do
	id=`identify -format %# "$line"`
	ext=`bash -c 'echo ".${1##*.}"' _ "$line"`
	echo "id = $id"
	echo "ext = $ext"
	echo "mv -n \"$line\" $tempident/$id$ext" >> /tmp/movethem.sh
done < /tmp/batch

#move them to the temp directory
sh /tmp/movethem.sh

cd $tempident
exiftool -r -d $MOUNTPOINT_DST/%Y/%Y-%m/%Y-%m-%d/%Y-%m-%d-%H%M%S_%%f.%%le "-filename<filemodifydate" "-filename<createdate" "-filename<datetimeoriginal" .

#remove all files that already existed
rm -r $tempident
