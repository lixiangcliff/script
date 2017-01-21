#!/usr/bin/env bash


BANDWIDTH_LIMIT_KBPS=100

rsync_dirs() {
    src_dir=$1
    dest_dir=$2
    printf "\nrsync files from: "$src_dir" to $dest_dir\n"
    rsync --bwlimit=$BANDWIDTH_LIMIT_KBPS -avzhe ssh --progress root@miwifi:$src_dir $dest_dir
    printf "\nrsync done! "
}

rsync_dirs "/extdisks/sda5/*Cliff*/*/*" "/var/backups/photos/phone/cliff"
rsync_dirs "/extdisks/sda5/*zhe*/*/*" "/var/backups/photos/phone/christina"
rsync_dirs "/extdisks/sda5/*Min*/*/*" "/var/backups/photos/phone/min"

