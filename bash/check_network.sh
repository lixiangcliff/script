#!/usr/bin/env bash

status_code=""

get_status_code() {
    status_code=$(curl -I -s -L "https://www.google.com/" | grep "HTTP/1.1" | awk '{print $2}')
}

RETRY_INTERVAL_IN_SECOND=5

get_status_code
if [[ $status_code != "200" ]]; then
    printf "\nNetwork is down! \nTry to restart network now! \n"
    sudo /etc/init.d/network-manager restart
    sleep ${RETRY_INTERVAL_IN_SECOND}
    get_status_code
    if [[ $status_code != "200" ]]; then
        printf "\nAfter restarting, network is still down!\n"
        exit 1
    else
        printf "\nAfter restarting, network is OK now!\n"
    fi
else
    printf "\nNetwork is OK!\n\n"
fi