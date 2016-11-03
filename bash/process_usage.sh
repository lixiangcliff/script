#!/usr/bin/env bash
# http://www.tecmint.com/find-linux-processes-memory-ram-cpu-usage/
ps -eo user:6,pid:6,ppid:6,cmd:80,%mem:4,%cpu:4 --sort=-%mem | head