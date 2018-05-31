#!/usr/bin/env bash

mypass=$(./get_property.sh "/home/pi/.secret/config.txt" "pihole_pw")

date
echo "sleep 120 seconds..."
sleep 60;
echo "restart all docker containers..."
docker restart $(docker ps -aq)

echo "sleep 15 seconds..."
sleep 15;

echo "reset pihole pw"
/usr/bin/expect <<EOF
spawn docker exec -it pihole sudo pihole -a -p
expect "Password"
send "$mypass\r"
expect "Confirm:"
send "$mypass\r"
expect eof
exit
EOF

echo "done!"
date