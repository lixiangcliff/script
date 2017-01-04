#!/usr/bin/env bash

cur_dir=`dirname $0`

public_ip=$(cat /home/cliff/.secret/public_ip)
jenkins_port=$(cat /home/cliff/.secret/jenkins_port)
webhook_url=$(cat /home/cliff/.secret/webhook_url)

statusCode=$(curl -I -s -L ${public_ip}:${jenkins_port} | grep "HTTP/1.1" | awk '{print $2}')

if [[ $statusCode == "" ]]; then
    statusCode="ERR_EMPTY_RESPONSE"
fi

if [[ $statusCode != "403" ]]; then
    $cur_dir/post_to_slack.sh -t "Jenkins is Down!" -b "Response status code is: ${statusCode}" -c "ccjenkins" -u ${webhook_url} -r "danger"
fi