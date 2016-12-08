#!/usr/bin/env bash

miwifi_pw=$(cat /home/cliff/.secret/miwifi_pw)
miwifi_ip=$(netstat -r -n | awk 'FNR == 3 {print $2}')

sshpass -p ${miwifi_pw} ssh root@${miwifi_ip}