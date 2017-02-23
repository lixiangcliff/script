#!/usr/bin/env bash

#this is to use local modified property to overwrite original ones

set() {
    orig=$1
    orig+=$2
    copy=$orig
    copy+=".copy"
    modi=$orig
    modi+=".modi"
    cp $orig $copy
    rm $orig
    cp $modi $orig
}

path="/Users/Cliff/IdeaProjects/c2/tests/webtest/src/test/resources/config/"
path2="/Users/Cliff/IdeaProjects/c2/tests/jenkins/script/util/"

set $path common.properties
set $path houzz3Env.properties
set $path stagingEnv.properties
set $path stghouzzEnv.properties
set $path prodEnv.properties
set $path2 CommonProperties.py

echo "properties set!"