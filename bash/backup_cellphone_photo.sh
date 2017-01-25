#!/usr/bin/env bash

BANDWIDTH_LIMIT_KBPS=200
LOG_PATH="/home/cliff/temp/rsync.log"
is_updated=false

rsync_dirs() {
    if [ -f "$LOG_PATH" ] ; then
        rm $LOG_PATH
    fi

    src_dir=$1
    dest_dir=$2
    printf "\e[43mrsync files from: "$src_dir" to $dest_dir \e[0m\n"
    rsync --bwlimit=$BANDWIDTH_LIMIT_KBPS -avzhe ssh --progress root@miwifi:$src_dir $dest_dir --log-file=$LOG_PATH
    printf "\e[42mrsync done!                               \e[0m\n"
    line_count=$(wc -l < $LOG_PATH)
    if [ "$line_count" -gt 3 ] ; then
        is_updated=true
    fi

    rm $LOG_PATH
}

rsync_dirs "/extdisks/sda5/*Cliff*/*/*" "/var/backups/photos/phone/cliff"
rsync_dirs "/extdisks/sda5/*zhe*/*/*" "/var/backups/photos/phone/christina"
rsync_dirs "/extdisks/sda5/*Min*/*/*" "/var/backups/photos/phone/min"

if [ "$is_updated" = false ] ; then
    printf "\e[41mNo new photos have been transferred! \e[0m\n"
else
	printf "\e[44mNew photos have been transferred! \e[0m\n"
fi