#!/usr/bin/env bash

dirs=$(ls -d /home/cliff/repo/*)
for dir in ${dirs}
#do
#	cd ${dir};
#	git checkout -- .
#    echo -e "Discarded all local changes"
#	git pull
#	echo -e "Updated repo under: "${dir}"\n"
#done
do
	cd ${dir};
	echo -e "\nUpdating repo under: "${dir}
	git checkout -- .
    #echo -e "Discarded all local changes"

    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
        echo "Already up-to-date"
    elif [ $LOCAL = $BASE ]; then
        #echo "Need to pull"

        echo -e "\n"
        git show
        echo -e "\n"

        git pull -q
	    echo -e "Updated repo under: "${dir}
    elif [ $REMOTE = $BASE ]; then
        echo "Need to push"
    else
        echo "Diverged"
    fi

    echo -e "\n"
done