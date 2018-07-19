#!/bin/sh
# rest of script
cd ./resource-tutorial
mvn clean install
cp target/twewcweightloss2018-1.0-SNAPSHOT.jar*.jar ../target-web/concourse-demo-web.jar
