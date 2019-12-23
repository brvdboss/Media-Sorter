FROM alpine:latest

RUN apk add --no-cache \
	exiftool \
	imagemagick \
	nfs-utils \
	bash \
	findutils \
	coreutils \
  && rm -rf /var/cache/apk/*

ENV FSTYPE_SRC nfs
ENV MOUNT_OPTIONS_SRC rw
ENV FSTYPE_SRC=nfs4
ENV MOUNTPOINT_SRC /mnt/nfs-src

ENV FSTYPE_DST nfs
ENV MOUNT_OPTIONS_DST rw
ENV FSTYPE_DST=nfs4
ENV MOUNTPOINT_DST /mnt/nfs-dst

COPY ./src/scripts/* /Media-Sorter/
RUN chmod +x /Media-Sorter/*.sh
RUN mkdir $MOUNTPOINT_DST
RUN mkdir $MOUNTPOINT_SRC

ENTRYPOINT ["/Media-Sorter/run.sh"]
