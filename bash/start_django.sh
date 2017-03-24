#!/usr/bin/env bash

cur_dir=`dirname $0`

env=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties env)
django_ip=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties django_ip)
django_port=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties django_port)
manage_path="/home/cliff/repo/ccfam/src/manage.py runserver "

#have this change for vm for now
#tmux new -d -s django $manage_path$django_ip":"$django_port
#echo "Start django tmux session"

python3 $manage_path$django_ip":"$django_port

# to get into the tmux session again:
# tmux a -t django
