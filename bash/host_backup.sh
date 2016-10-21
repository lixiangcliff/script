#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################


# What to backup. 
backup_files="/home /var/backups/jenkins /var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/media/cliff/VIDEO1/ubuntu-backup"

#Delete all tar files that is older than 10 days
rmFilename=`date --date='10 days ago' +%Y-%m-%d`
rm $dest/"*"$rmFilename"*"


# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
archive_file="$hostname-$timestamp.tgz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest