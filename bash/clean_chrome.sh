#!/usr/bin/env bash

echo 'killing all chromedriver processes...';
killall chromedriver;
echo 'killing all chrome processes...';
pkill -f chrome;
echo 'removing tmp files, first removing /tmp/.org.chromium.Chromium.*';
rm -rf /tmp/.org.chromium.Chromium.*
echo 'removing /tmp/.com.google.Chrome.*';
rm -rf /tmp/.com.google.Chrome.*
echo 'removing /tmp/.X-lock';
rm -rf /tmp/X*-lock