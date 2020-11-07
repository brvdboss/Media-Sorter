#!/bin/sh

#Needed for nfs, -f option to prevent it forking and not being ready when the mount commands are executed
rpcbind

#mount nfs volume SRC
mount -t "$FSTYPE_SRC" -o "$MOUNT_OPTIONS_SRC" "$SERVER_SRC:$SHARE_SRC" "$MOUNTPOINT_SRC"

#mount nfs volume DST
mount -t "$FSTYPE_DST" -o "$MOUNT_OPTIONS_DST" "$SERVER_DST:$SHARE_DST" "$MOUNTPOINT_DST"

# Run the main script every X seconds
# This will drift a tiny little bit, probably isn't that much of an issue
# We don't combine image and video files as the processing time of video files is
# significantly longer. Including videos would delay the processing of images
# It's recommended to run two containers, one for video and one for images. This
# allows to set different type of constraints (memory, cpu etc) on each container
# They can both run on the same mounts and will not interfere with each other

#In case of image files
if [ $MEDIATYPE = "image"]
then
  while :; do sleep $POLLING_INTERVAL & /Media-Sorter/monitorandpublish.sh; wait; done
fi

#in case of video files
if [ $MEDIATYPE = "video"]
then
  while :; do sleep $POLLING_INTERVAL & /Media-Sorter/monitorandpublish-video.sh; wait; done
fi
