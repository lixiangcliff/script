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

# http://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git

do
	cd ${dir};
	echo -e "\nChecking repo under: "${dir}
	git checkout -- .
    #echo -e "Discarded all local changes"

    #git remote update

    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
        echo "Already up-to-date"
    else
        #echo "Need to pull"
	    echo -e "Start updating repo under: "${dir}"\n"

        git pull -q

        git show

	    echo -e "Finish updating repo under: "${dir}"\n"
    fi

    echo -e "\n"
done