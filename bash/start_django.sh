#!/usr/bin/env bash

tmux new -d -s django "/home/cliff/repo/website/manage.py runserver 192.168.31.199:8000"

echo "Start django tmux session"

# to get into the tmux session again:
# tmux a -t django