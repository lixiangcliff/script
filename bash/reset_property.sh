#!/usr/bin/env bash

#this is to reset property back

reset() {
    orig=$1
    orig+=$2
    copy=$orig
    copy+=".copy"
    if [ -f $copy ]
    then
        rm $orig
        cp $copy $orig
        rm $copy
    fi
}


path="/Users/Cliff/IdeaProjects/c2/tests/webtest/src/test/resources/config/"
path2="/Users/Cliff/IdeaProjects/c2/tests/jenkins/script/util/"

reset $path common.properties
reset $path stagingEnv.properties
reset $path houzz3Env.properties
reset $path stghouzzEnv.properties
reset $path prodEnv.properties
reset $path2 CommonProperties.py

echo "properties reset!"