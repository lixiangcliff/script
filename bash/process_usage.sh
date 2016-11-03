#!/usr/bin/env bash
# http://www.tecmint.com/find-linux-processes-memory-ram-cpu-usage/
#ps -eo %mem:5,%cpu:5,cmd:80,user:6,pid:6,ppid:6 --sort=-%mem | head
ps -axceo %mem:5,%cpu:5,cmd:10,user:5,pid:5,ppid:5 --sort=-%mem | head