#!/usr/bin/env bash

cur_dir=`dirname $0`

miwifi_pw=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties miwifi_pw)
miwifi_ip=$(netstat -r -n | awk 'FNR == 3 {print $2}')

sshpass -p ${miwifi_pw} ssh root@${miwifi_ip}