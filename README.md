# Media-Sorter
Organizing media files by date and choosing a unique filename

When handling a large amount of media files, duplicate filenames are likely to occur. We wish to generate a unique filename and put the files ina time based directory structure.

## Filenames
By using the `identify` command that's part of the ImageMagick suite we can generate a unique identifier. In the case of video files, the unique identifier of the first frame of the video is used.

> **Warning**: ImageMagick has changed how the hash of the file was calculated in the past and potentially could do that again in the future. It is claimed to be stable and consistent among different platforms, but it might change at some point

By using the date in the file (trying to find the best date match in this order):
1. original date (generated by camera)
2. creation date (on the file system)
3. modify date

we generate a filename in the style of `<year>-<month>-<day>-<timeofday>-<identifier>.extension`
organized in a folder structure: `<year>/<month>/<day>` (all fully written out)
Example: `/2015/2015-03/2015-03-10/2015-03-10-093817_f5fd9eb9d75848ae916c339db4d58314f02e9de684317ac6847ee8eb76b384d4.jpg`

Processing video and images is separated as they might have very different processing times due to the filesizes
The desired processing "image" or "video" can be set by defining the `MEDIATYPE` environment variable. There is deliberately no default type to avoid mistakes.  If no `MEDIATYPE` is defined, the start script simply exits. By default its set to image.

The file extensions you wish to support can be defined using the `IMGEXT` and `VIDEXT` environment variables. These are case insensitive.  See the dockerfile for the default values.

## NFS mounts
The docker container expects 2 NFS mounts, a source ingest folder where files are dropped that need to be processed. This folder is scanned continuously and a destination folder where the files are to be stored. Files are moved, not copied.
