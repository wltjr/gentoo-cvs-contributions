#!/bin/bash

source /etc/rsync/gentoo-mirror.conf

echo "Started update at" `date` >> $0.log 2>&1
logger -t rsync "re-rsyncing the gentoo-portage tree"
${RSYNC} ${OPTS} ${SRC} ${DST} >> $0.log 2>&1

echo "End: "`date` >> $0.log 2>&1 

