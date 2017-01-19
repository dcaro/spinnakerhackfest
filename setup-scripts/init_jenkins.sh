#!/bin/bash

# If you want to export the job you can run the following command 
# java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://user:password@localhost:8080 get-job "Build Hello World" > jenkins_job.xml

# This script to configure the following stuff from Jenkins automatically: JDK, Oracle user and password, Gradle 
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://jenkins:Passw0rd@localhost:8080 groovy setup_jenkins.groovy 

