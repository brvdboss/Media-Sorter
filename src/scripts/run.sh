#!/bin/sh

#Needed for nfs, -f option to prevent it forking and not being ready when the mount commands are executed
rpcbind

#mount nfs volume SRC
mount -t "$FSTYPE_SRC" -o "$MOUNT_OPTIONS_SRC" "$SERVER_SRC:$SHARE_SRC" "$MOUNTPOINT_SRC"

#mount nfs volume DST
mount -t "$FSTYPE_DST" -o "$MOUNT_OPTIONS_DST" "$SERVER_DST:$SHARE_DST" "$MOUNTPOINT_DST"

# Run the main script every X seconds
#This will drift a tiny little bit, probably isn't that much of an issue
while :; do sleep $POLLING_INTERVAL & /Media-Sorter/monitorandpublish.sh; wait; done

#/Media-Sorter/whenever.sh '$MOUNTPOINT_SRC\*.jpg$' 'echo {}'