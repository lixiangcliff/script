#!/usr/bin/env bash

# http://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
# http://testerfenster.com/blog/jenkins-tutorials-add-color-to-console-output/
# https://github.com/dblock/jenkins-ansicolor-plugin


dirs=$(ls -d /home/cliff/repo/*)
for dir in ${dirs}
do
	cd ${dir};
	echo -e "\nChecking repo under: "${dir}
	git checkout -- .
    #echo -e "Discarded all local changes"
    git remote update

    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
        echo "Already up-to-date"
    else
	    #echo -e "\nStart updating repo under: "${dir}"\n"
	    #echo "\033[43m Starting updating repo under: "${dir}"\033[0m"
	    printf "\e[43mStart updating repo under: "${dir}"\e[0m\n"
        git pull -q

        git show

	    #echo -e "\nFinish updating repo under: "${dir}"\n"
	    #echo "\033[44m Finish updating repo under: "${dir}"\033[0m"
	    printf "\e[44mFinish updating repo under: "${dir}"\e[0m\n"

    fi
    echo -e "\n"
done

