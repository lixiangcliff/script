#!/usr/bin/env bash

cur_dir=`dirname $0`

public_ip=$(cat /home/cliff/.secret/public_ip)
jenkins_port=$(cat /home/cliff/.secret/jenkins_port)
webhook_url=$(cat /home/cliff/.secret/webhook_url)

statusCode=""

get_status_code() {
    statusCode=$(curl -I -s -L ${public_ip}:${jenkins_port} | grep "HTTP/1.1" | awk '{print $2}')
    if [[ $statusCode == "" ]]; then
        statusCode="ERR_EMPTY_RESPONSE"
    fi
}

RETRY_INTERVAL_IN_SECOND=60

get_status_code
if [[ $statusCode != "403" ]]; then
    $cur_dir/post_to_slack.sh -t "Jenkins is Down!" -b "Response status code is: ${statusCode}. Now restart jenkins service and retry in ${RETRY_INTERVAL_IN_SECOND} seconds" -c "ccjenkins" -u ${webhook_url} -r "danger"
    sudo service jenkins restart
    sleep ${RETRY_INTERVAL_IN_SECOND}
    get_status_code
    if [[ $statusCode != "403" ]]; then
        $cur_dir/post_to_slack.sh -t "After restarting, Jenkins is still Down!" -b "Response status code is: ${statusCode}." -c "ccjenkins" -u ${webhook_url} -r "danger"
    else
        $cur_dir/post_to_slack.sh -t "Jenkins is up now!" -b "After restarting jenkins service is running again" -c "ccjenkins" -u ${webhook_url} -r "good"
    fi
fi