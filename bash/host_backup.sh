#!/bin/bash

#https://help.ubuntu.com/lts/serverguide/backup-shellscripts.html
####################################
#
# Backup to NFS mount script.
#
####################################

#add ssh key for root against miwifi
ssh-keygen -R miwifi
eval "$(ssh-agent -s)"
ssh-add /root/.ssh/id_rsa_miwifi

#save installed package list
dpkg --get-selections | grep -v deinstall > /home/cliff/installed_packages.txt

# What to backup.
backup_files="/home /var/backups/jenkins /var/spool/mail /var/spool/cron /etc /root /boot /var/www"
exclude_files="/home/cliff/.cache"

# Where to backup to.
local_dest="/var/backups/ubuntu-backup/"
external_dest="/media/cliff/FLASHDISK/ubuntu-backup/"
remote_dest="/extdisks/sda5/ubuntu-backup/"
BANDWIDTH_LIMIT_KBPS=200

#Delete all tar files that is older than 10 days
#rmFilename=`date --date='10 days ago' +%Y-%m-%d`
#rm $dest/"*"$rmFilename"*"

#Delete all .tgz files that is older than x days
STORE_INTERVAL=7

files_to_rm=`find ${local_dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz'`
find ${local_dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz' -exec rm -- {} \;
printf "\nOn local: "$local_dest" remove files older than "${STORE_INTERVAL}" days: \n"${files_to_rm}"\n"

#files_to_rm=`find ${dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz'`
#find ${dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz' -exec rm -- {} \;
#printf "\nOn external, "$dest" remove files older than "${STORE_INTERVAL}" days: \n"${files_to_rm}"\n"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
archive_file="$hostname-$timestamp.tgz"

# list large files:
printf "\nTop largest size dirs to backup:\n"
du -Sh  $backup_files | sort -hr | head -30 | grep -v $exclude_files

# Print start status message.
printf "\nBacking up $backup_files to $local_dest$archive_file , $external_dest$archive_file and $remote_dest$archive_file"
printf "\nExcluding dirs: $exclude_files\n\n"

# Backup the files in local using tar.
#tar --exclude=${exclude_files} -zcf $local_dest$archive_file $backup_files
#cp $local_dest$archive_file $dest$archive_file

#rsync to external (ignore owner, group and permission)
printf "\nrsync to external: \n"
rsync -rltvzhe ssh --progress $local_dest $external_dest --delete

#rsync to remote (ignore owner, group and permission)
printf "\nrsync to remote: \n"
rsync --bwlimit=$BANDWIDTH_LIMIT_KBPS -rltvzhe "ssh -o 'StrictHostKeyChecking no'" --progress  $local_dest root@miwifi:$remote_dest --delete
# Long listing of files in $dest to check file sizes.
printf "\n\nOn local: "$local_dest"\n"
ls -rlh $local_dest
printf "\nOn external: "$external_dest"\n"
ls -rlh $external_dest
printf "\nOn remote: "$remote_dest"\n"
ssh -o "StrictHostKeyChecking no" root@miwifi "du -sh "$remote_dest"; ls -rlh "$remote_dest

# Print end status message.
printf "\nBackup finished\n"
