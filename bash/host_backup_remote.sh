#!/bin/bash
#this script is to make backup to remote host
#https://help.ubuntu.com/lts/serverguide/backup-shellscripts.html
####################################
#
# Backup to NFS mount script.
#
####################################

#add ssh key for miwifi
eval "$(ssh-agent -s)"
ssh-add /home/cliff/.ssh/id_rsa_miwifi

#save installed package list
dpkg --get-selections | grep -v deinstall > /home/cliff/installed_packages.txt

# Where to backup to.
dest="/extdisks/sda5/ubuntu-backup/"
local_dest="/var/backups/ubuntu-backup/"

# What to backup. 
backup_files="/home /var/backups/jenkins /var/spool/mail /var/spool/cron /etc /root /boot /var/www"
exclude_files="/home/cliff/.cache "

#Delete all tar files that is older than 10 days
#rmFilename=`date --date='10 days ago' +%Y-%m-%d`
#rm $dest/"*"$rmFilename"*"

#Delete all .tgz files that is older than x days
#this is to remove local backup, remote backup removal needs to be added later

STORE_INTERVAL=7
files_to_rm=`find ${local_dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz'`
find ${local_dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz' -exec rm -- {} \;
printf "\nOn local, remove files older than "${STORE_INTERVAL}" days: \n"${files_to_rm}

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
archive_file="$hostname-$timestamp.tgz"

# list large files:
printf "\nTop largest size dirs to backup:\n"
du -Sh  $backup_files | sort -hr | head -30 | grep -v $exclude_files

# Print start status message.
printf "\nBacking up $backup_files to $dest$archive_file"
printf "\nExcluding dirs: $exclude_files\n\n"

# Backup the files locally and scp to remote.
tar --exclude=${exclude_files} -zcf $local_dest$archive_file $backup_files
scp $local_dest$archive_file "root@miwifi":$dest

# Long listing of files in $dest to check file sizes.
printf "\nOn local:"
ls -rlh $local_dest
printf "\nOn remote:"
ssh root@miwifi "du -sh "$dest"; ls -rlh "$dest

# Print end status message.
printf "\nBackup finished\n"