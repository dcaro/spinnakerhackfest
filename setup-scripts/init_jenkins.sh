#!/bin/bash


# This script to configure the following stuff from Jenkins automatically: JDK, Oracle user and password, Gradle 
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://jenkins:Passw0rd@localhost:8080 groovy setup_jenkins.groovy 

# Create the job from the XML template 
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://jenkins:Passw0rd@localhost:8080 create-job MyJob < jenkins_job.xml
