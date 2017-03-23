#!/usr/bin/env bash

cur_dir=`dirname $0`

slack_token=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties slack_token)
cd /home/cliff/repo/ccbot/

tmux new -d -s ccbot "HUBOT_SLACK_TOKEN="${slack_token}" ./bin/hubot --adapter slack"

echo "Start ccbot tmux session"

# to get into the tmux session again:
# tmux a -t ccbot