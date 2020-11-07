#!/bin/sh

if [ -z "$LOCALE" ];
then
	LOCALE="en-US"
fi

echo "Scanning & Processing videos"

tempident="/tmp/ident-videos"
mkdir -p $tempident

#Find all media image files
extensions="avi mov mp4 vob mpg mpeg wmv webm"
rm /tmp/movethem-video.sh
rm /tmp/batch-video
for i in $extensions;
do
	find $MOUNTPOINT_SRC -type f -cmin +1 -iname "*.$i" ! -path "*__thumb*" | head -n 10 >> /tmp/batch-video
done

while read line
do
	# We run the identify on the first frame
	id=`identify -format %# "$line[0]"`
	ext=`bash -c 'echo ".${1##*.}"' _ "$line"`
	echo "id = $id"
	echo "ext = $ext"
	echo "mv -n \"$line\" $tempident/$id$ext" >> /tmp/movethem-video.sh
done < /tmp/batch-video

#move them to the temp directory
sh /tmp/movethem-video.sh

cd $tempident
exiftool -r -d $MOUNTPOINT_DST/%Y/%Y-%m/%Y-%m-%d/%Y-%m-%d-%H%M%S_%%f.%%le "-filename<filemodifydate" "-filename<createdate" "-filename<datetimeoriginal" .

#remove all files that already existed
rm -r $tempident
