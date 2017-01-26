#!/usr/bin/env bash

status_code=$(curl -I -s -L "https://www.google.com/" | grep "HTTP/1.1" | awk '{print $2}')

if [[ $status_code != "200" ]]; then
    printf "Network is down!"
    exit 1
fi