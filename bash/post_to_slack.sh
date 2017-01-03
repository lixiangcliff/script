#!/usr/bin/env bash

# https://api.slack.com/incoming-webhooks#customizations_for_custom_integrations
# https://api.slack.com/docs/message-attachments
# http://www.sulhome.com/blog/12/post-messages-to-slack-from-bash
function usage {
    programName=$0
    echo "description: use this program to post messages to Slack channel"
    echo "usage: $programName [-t \"sample title\"] [-b \"message body\"] [-r \"message color\"] [-c \"mychannel\"] [-u \"slack url\"]"
    echo "    -t    the title of the message you are posting"
    echo "    -b    The message body"
    echo "    -c    The channel you are posting to"
    echo "    -u    The slack hook url to post to"
    echo "    -r    The color of message"
    exit 1
}

#arg order matters!
while getopts ":t:r:u:b:c:h" opt; do
  case ${opt} in
    t) msgTitle="$OPTARG"
    ;;
    r) msgColor="$OPTARG"
    ;;
    u) slackUrl="$OPTARG"
    ;;
    b) msgBody="$OPTARG"
    ;;
    c) channelName="$OPTARG"
    ;;
    h) usage
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

read -d '' payLoad << EOF
{
        "channel": "#${channelName}",
        "username": "$(hostname)",
        "icon_emoji": ":ubuntu:",
        "attachments": [
            {
                "fallback": "${msgTitle}",
                "color": "${msgColor}",
                "title": "${msgTitle}",
                "fields": [{
                    "value": "${msgBody}",
                    "short": false
                }]
            }
        ]
    }
EOF


#statusCode=$(curl \
#        --write-out %{http_code} \
#        --silent \
#        --output /dev/null \
#        -X POST \
#        -H 'Content-type: application/json' \
#        --data "${payLoad}" ${slackUrl})

curl --silent --output /dev/null \
-X POST -H 'Content-type: application/json' \
--data "${payLoad}" ${slackUrl}