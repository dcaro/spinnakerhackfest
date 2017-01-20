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
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
   -ou)
   ORACLE_USER="$2"
   shift
   ;;
   -op)
   ORACLE_PWD="$2"
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
   -ju)
   JENKINS_USER="$2"
   ;;
   -jp)
   JENKINS_PWD="$2"
   ;;
   *)

   ;;
esac
shift
done

echo ORACLE_USER = "${ORACLE_USER}"
echo ORACLE_PWD = "${ORACLE_PWD}"
echo GITHUB_USER = "${GITHUB_USER}"
echo GITHUB_PWD = "${GITHUB_PWD}"
echo JENKINS_USER = "${JENKINS_USER}"
echo JENKINS_PWD = "${JENKINS_PWD}"

# Installing Aptly
./setup_aptly.sh

# This script to configure the following stuff from Jenkins automatically: JDK, Oracle user and password, Gradle
# java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://jenkins:Passw0rd@localhost:8080 groovy setup_jenkins.groovy user@oracle.com P@ssw0rd githubuser githubpassword
sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://$JENKINS_USER:$JENKINS_PWD@localhost:8080 groovy setup_jenkins.groovy $ORACLE_USER $ORACLE_PWD $GITHUB_USER $GITHUB_PWD

sudo service jenkins stop 
sudo service jenkins start 