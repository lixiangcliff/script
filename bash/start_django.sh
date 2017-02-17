#!/usr/bin/env bash
env=$(cat /home/cliff/.secret/env)
django_ip=$(cat /home/cliff/.secret/django_ip)
django_port=$(cat /home/cliff/.secret/django_port)
manage_path="/home/cliff/repo/ccfam/src/manage.py runserver "

tmux new -d -s django $manage_path$django_ip":"$django_port

echo "Start django tmux session"

# to get into the tmux session again:
# tmux a -t django