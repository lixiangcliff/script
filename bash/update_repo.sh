#!/usr/bin/env bash

repo=$1

dir=/home/cliff/repo/${repo}"*"
cd ${dir};
git pull
echo -e "Updated repo under: "${dir}"\n"

