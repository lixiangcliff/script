#!/usr/bin/env bash

status_code=$(curl -I -s -L "https://www.google.com/" | grep "HTTP/1.1" | awk '{print $2}')

if [[ $status_code != "200" ]]; then
    printf "\nNetwork is down!\n\n"
    exit 1
else
    printf "\nNetwork is OK!\n\n"
fi