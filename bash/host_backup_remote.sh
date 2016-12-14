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

# What to backup. 
backup_files="/home /var/backups/jenkins /var/spool/mail /var/spool/cron /etc /root /boot /var/www"
exclude_files="/home/cliff/.cache"

# Where to backup to.
dest="/extdisks/sda5/ubuntu-backup"

#Delete all tar files that is older than 10 days
#rmFilename=`date --date='10 days ago' +%Y-%m-%d`
#rm $dest/"*"$rmFilename"*"

#Delete all .tgz files that is older than x days
#ssh root@miwifi
#cd ${dest}
#STORE_INTERVAL=7
#files_to_rm=`find ${dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz'`
#find ${dest} -type f -mtime +${STORE_INTERVAL} -name '*.tgz' -exec rm -- {} \;
#echo
#echo -e "Remove files older than "${STORE_INTERVAL}" days: "${files_to_rm}
#exit

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
archive_file="$hostname-$timestamp.tgz"

# list large files:
echo
echo "Top largest size dirs:"
du -Sh  $backup_files | sort -hr | head -30 | grep -v $exclude_files

# Print start status message.
echo
echo "Backing up $backup_files to $dest/$archive_file"
echo "Excluding dirs: $exclude_files"
date
echo

# Backup the files using tar.
temp_dir="/home/cliff/temp/"
tar --exclude=${exclude_files} -zcf $temp_dir$archive_file $backup_files
scp $temp_dir$archive_file "root@miwifi":$dest
rm $temp_dir$archive_file

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ssh root@miwifi "du -sh "$dest"; ls -rlh "$dest
