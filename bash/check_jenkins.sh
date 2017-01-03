#!/usr/bin/env bash

public_ip=$(cat /home/cliff/.secret/public_ip)
jenkins_port=$(cat /home/cliff/.secret/jenkins_port)
webhook_url=$(cat /home/cliff/.secret/webhook_url)
statusCode=$(curl -I -s -L ${public_ip}:${jenkins_port} | grep "HTTP/1.1" | awk '{print $2}')
if [[ $statusCode != "403" ]]; then
    ./post_to_slack.sh -t "Jenkins is Down!" -b "Status code is: ${statusCode}" -c "ccjenkins" -u ${webhook_url} -r "danger"
fi