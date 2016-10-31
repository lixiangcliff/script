#!/usr/bin/env bash

dirs=$(ls -d /home/cliff/repo/*)
for dir in ${dirs}
do
	cd ${dir};
	git checkout -- .
    echo -e "Discarded all local changes"
	git pull
	echo -e "Updated repo under: "${dir}"\n"
done
