#!/bin/bash

# Default values 
JENKINS_USER="jenkins"
JENKINS_PWD="Passw0rd"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
   -ju)
   JENKINS_USER="$2"
   shift
   ;;
   -jp)
   JENKINS_PWD="$2"
   shift
   ;;
   -gu)
   GITHUB_USER="$2"
   shift
   ;;
   -gp)
   GITHUB_PWD="$2"
   shift
   ;;
   *)

   ;;
esac
shift
done

echo JENKINS_USER = "$JENKINS_USER"
echo JENKINS_PWD = "$JENKINS_PWD"
echo GITHUB_USER = "$GITHUB_USER"
echo GITHUB_PWD = "$GITHUB_PWD"

#Calling the Jenkins CLI to create a sample job
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://$JENKINS_USER:$JENKINS_PWD@localhost:8080 groovy sample_job.groovy $GITHUB_USER $GITHUB_PWD

