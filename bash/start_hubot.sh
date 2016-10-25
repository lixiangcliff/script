#!/usr/bin/env bash

slack_token=token=$(cat /home/cliff/.secret/slack_token)
cd /home/cliff/repo/ccbot/

tmux new -d -s ccbot "HUBOT_SLACK_TOKEN="&{slack_token}" ./bin/hubot --adapter slack"

# to get into the tmux seesion again:
# tmux a -t ccbot