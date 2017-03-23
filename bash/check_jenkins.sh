#!/usr/bin/env bash

cur_dir=`dirname $0`

public_ip=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties public_ip)
jenkins_port=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties jenkins_port)
webhook_url=$(source $cur_dir/get_property.sh /home/cliff/.secret/properties webhook_url)

status_code=""

get_status_code() {
    status_code=$(curl -I -s -L ${public_ip}:${jenkins_port} | grep "HTTP/1.1" | awk '{print $2}')
    if [[ $status_code == "" ]]; then
        status_code="ERR_EMPTY_RESPONSE"
    fi
}

RETRY_INTERVAL_IN_SECOND=60

get_status_code
if [[ $status_code != "403" ]]; then
    $cur_dir/post_to_slack.sh -t "Jenkins is down!" -b "Response status code is: ${status_code}. Now restart jenkins service and retry in ${RETRY_INTERVAL_IN_SECOND} seconds" -c "ccjenkins" -u ${webhook_url} -r "danger"
    sudo service jenkins restart
    sleep ${RETRY_INTERVAL_IN_SECOND}
    get_status_code
    if [[ $status_code != "403" ]]; then
        $cur_dir/post_to_slack.sh -t "After restarting, Jenkins is still Down!" -b "Response status code is: ${status_code}." -c "ccjenkins" -u ${webhook_url} -r "danger"
    else
        $cur_dir/post_to_slack.sh -t "Jenkins is up now!" -b "After restarting jenkins service is running again" -c "ccjenkins" -u ${webhook_url} -r "good"
    fi
fi