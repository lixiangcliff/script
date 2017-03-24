#!/usr/bin/env bash

cur_dir=`dirname $0`

env=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties env)
django_ip=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties django_ip)
django_port=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties django_port)
manage_path="/home/cliff/repo/ccfam/src/manage.py runserver "


#tmux new -d -s django python3  $manage_path$django_ip":"$django_port
echo "Start django tmux session"


# to get into the tmux session again:
# tmux a -t django
