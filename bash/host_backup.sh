#!/bin/bash
#https://help.ubuntu.com/lts/serverguide/backup-shellscripts.html
####################################
#
# Backup to NFS mount script.
#
####################################

# What to backup. 
backup_files="/home /var/backups/jenkins /var/spool/mail /var/spool/cron /etc /root /boot /opt"
exclude_files="/home/cliff/.cache"

# Where to backup to.
dest="/media/cliff/APP_GAME/ubuntu-backup"

#Delete all tar files that is older than 10 days
#rmFilename=`date --date='10 days ago' +%Y-%m-%d`
#rm $dest/"*"$rmFilename"*"

#Delete all .tgz files that is older than x days
STORE_INTERVAL=7
files_to_rm=`find ${dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz'`
find ${dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz' -exec rm -- {} \;
echo -e "Remove files older than "${STORE_INTERVAL}" days: "${files_to_rm}

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
archive_file="$hostname-$timestamp.tgz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
echo "Excluding dirs: $exclude_files"
date
echo

# Backup the files using tar.
tar --exclude=${exclude_files} -zcf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -rlh $dest
