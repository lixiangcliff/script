#!/usr/bin/env bash

#this is to commit code to c2 repository
#git add fileFullPath1 fileFullPath2 ...
#git commit -m "check in message"
#git pull --rebase
#git push origin master

prePath=$(pwd)

args=("$@")
count=$#

#if under webtest dir, check whether forgot to revert back config before commit
if [[ "${prePath}" == *webtest* ]] && grep -q "eciaa310" $prePath"/src/test/resources/config/stagingEnv.properties"; then
        echo "Forgot to 'rp'. Forbid to commit!"
else
    if [ $1 == "u" ]; then
        git add -$1
        echo "Added -"$1
    elif [ $1 == "a" ]; then
            git add -A
        echo "Added -A"
    else
        for ((c=0; c<$count-1; c++))
        do
            git add $prePath${args[c]}
            echo "Added "${args[c]}
        done
    fi

    #git add $prePath$1
    git commit -m "${args[$count-1]}"
    git pull --rebase
    git push origin master
fi