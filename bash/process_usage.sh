#!/usr/bin/env bash
# http://www.tecmint.com/find-linux-processes-memory-ram-cpu-usage/
ps -eo user,pid,ppid,cmd:80,%mem,%cpu --sort=-%mem | head