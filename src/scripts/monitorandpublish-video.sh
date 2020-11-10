#!/bin/sh

if [ -z "$LOCALE" ];
then
	LOCALE="en-US"
fi

echo "Scanning & Processing videos"

tempident="/tmp/ident-videos"
mkdir -p $tempident

#Find all media image files
extensions=$VIDEXT
rm /tmp/movethem-video.sh
rm /tmp/batch-video
for i in $extensions;
do
	find $MOUNTPOINT_SRC -type f -cmin +5 -iname "*.$i" ! -path "*__thumb*" | head -n 10 >> /tmp/batch-video
done

while read line
do
	# We run the identify on the first frame
	# extract the first frame with ffmpeg as this has the most extensive support
	# for video formats.
	#clean up any previous frame0 to avoid it being picked up for the wrong file
	rm /tmp/frame0.bmp
	ffmpeg -i $line -vframes 1 /tmp/frame0.bmp
	#run the identify command on the bmp
	#this basically generates the same output as:
	#id=`identify -format %# "$line[0]"`
	#however, going through ffmpeg we remove the need to have an appropriate delegate
	#compiled in with imagemagick
	id=`identify -format %# /tmp/frame0.bmp
	ext=`bash -c 'echo ".${1##*.}"' _ "$line"`
	rm /tmp/frame0.bmp
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
