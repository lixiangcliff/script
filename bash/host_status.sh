#!/bin/bash

cpu_usage=$(top -bn1 | grep load | awk '{print $(NF-2)}')
cpu_usage=${cpu_usage::-1}
cpu_usage_percent=$(echo "scale=2; $cpu_usage * 100 / 4" | bc -l)
printf "CPU    Usage: %s (%s%%)\n" $cpu_usage $cpu_usage_percent

free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'

df -h | awk '$NF=="/"{printf "Disk   Usage: %d/%dGB (%.2f%%)\n", $3,$2,$5}'

sleep 1.0

sensors | grep 'Core 0'
sensors | grep 'Core 1'
