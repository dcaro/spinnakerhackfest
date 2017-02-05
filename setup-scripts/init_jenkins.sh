#!/bin/bash

# Usage : ./init_jenkins.sh -ou oracleuser@oracle.com -op oraclepassword -gu githubuser -gp githubpass -ju jenkins -jp Passw0rd
# -ou : The oracle usernme used to download the JDK 
# -op : The password associated with this username 
# -gu : the github username used to access the source code on github
# -gp : the github password associared to the the username
# -ju : the jenkins usermane that will create the intial job
# -jp : the jenkins user password 

# If you want to export the job you can run the following command 
# java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://user:password@localhost:8080 get-job "Build Hello World" > jenkins_job.xml

# This script to configure Jenkins automatically with a groovy script 
# Default values
ORACLE_USER=""
ORACLE_PASSWORD=""
JENKINS_USER=""
JENKINS_PWD=""
APTLY_REPO_NAME=""
WORKDIR="/opt/azure_jenkins_config"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
   -ou)
   ORACLE_USER="$2"
   shift
   ;;
   -op)
   ORACLE_PASSWORD="$2"
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
   -ar)
   APTLY_REPO_NAME="$2"
   shift
   ;;
   *)

   ;;
esac
shift
done

# Installing Aptly
$WORKDIR/setup_aptly.sh -ar $APTLY_REPO_NAME
# Pausing to allow nginx to start completely
sleep 10

# This script to configure the following stuff from Jenkins automatically: JDK, Oracle user and password, Gradle
sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://$JENKINS_USER:$JENKINS_PWD@localhost:8080 groovy $WORKDIR/init.groovy $ORACLE_USER $ORACLE_PASSWORD

sudo service jenkins stop 
sudo service jenkins start 