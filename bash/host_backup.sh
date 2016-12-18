#!/bin/bash
#https://help.ubuntu.com/lts/serverguide/backup-shellscripts.html
####################################
#
# Backup to NFS mount script.
#
####################################

#save installed package list
dpkg --get-selections | grep -v deinstall > /home/cliff/installed_packages.txt

# What to backup.
backup_files="/home /var/backups/jenkins /var/spool/mail /var/spool/cron /etc /root /boot /var/www"
exclude_files="/home/cliff/.cache"

# Where to backup to.
dest="/media/cliff/FLASHDISK/ubuntu-backup/"
local_dest="/var/backups/ubuntu-backup/"

#Delete all tar files that is older than 10 days
#rmFilename=`date --date='10 days ago' +%Y-%m-%d`
#rm $dest/"*"$rmFilename"*"

#Delete all .tgz files that is older than x days
STORE_INTERVAL=7

files_to_rm=`find ${local_dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz'`
find ${local_dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz' -exec rm -- {} \;
printf "\nOn local: "$local_dest" remove files older than "${STORE_INTERVAL}" days: \n"${files_to_rm}"\n"

files_to_rm=`find ${dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz'`
find ${dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz' -exec rm -- {} \;
printf "\nOn external, "$dest" remove files older than "${STORE_INTERVAL}" days: \n"${files_to_rm}"\n"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
archive_file="$hostname-$timestamp.tgz"

# list large files:
printf "\nTop largest size dirs to backup:\n"
du -Sh  $backup_files | sort -hr | head -30 | grep -v $exclude_files

# Print start status message.
printf "\nBacking up $backup_files to $local_dest$archive_file and $dest$archive_file"
printf "\nExcluding dirs: $exclude_files\n\n"

# Backup the files using tar.
tar --exclude=${exclude_files} -zcf $local_dest$archive_file $backup_files
cp $local_dest$archive_file $dest$archive_file

# Long listing of files in $dest to check file sizes.
printf "\n\nOn local: "$local_dest"\n"
ls -rlh $local_dest
printf "\nOn external: "$dest"\n"
ls -rlh $dest

# Print end status message.
printf "\nBackup finished\n"
