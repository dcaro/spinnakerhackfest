#!/bin/bash

SETUP_SCRIPTS_LOCATION="/opt/azure_jenkins_config/"
CONFIG_AZURE_SCRIPT="config_azure.sh"
CLEAN_STORAGE_SCRIPT="clear_storage_config.sh"
CREATE_STORAGE_SCRIPT="config_azure_jenkins_storage.sh"
CREATE_SERVICE_PRINCIPAL_SCRIPT="create_service_principal.sh"
INITIAL_JENKINS_CONFIG="init_jenkins.sh"
APTLY_SCRIPT="setup_aptly.sh"
JENKINS_JOB="jenkins_job.xml"
JENKINS_GROOVY="setup_jenkins.groovy"
#SOURCE_URI="https://raw.githubusercontent.com/arroyc/azure-quickstart-templates/master/azure-jenkins/setup-scripts/"
SOURCE_URI="https://raw.githubusercontent.com/dcaro/spinnakerhackfest/master/setup-scripts/"
ORACLE_USER="$2"
ORACLE_PASSWORD="$3"

#delete any previous user if there is any
if [ ! -d $JENKINS_USER ]
then
    sudo rm -rvf $JENKINS_USER
fi
#restart jenkins
sudo service jenkins restart

if [ ! -d "$SETUP_SCRIPTS_LOCATION" ]; then
  sudo mkdir $SETUP_SCRIPTS_LOCATION
fi

# Download config_azure script
sudo wget -O $SETUP_SCRIPTS_LOCATION$CONFIG_AZURE_SCRIPT $SOURCE_URI$CONFIG_AZURE_SCRIPT
sudo chmod +x $SETUP_SCRIPTS_LOCATION$CONFIG_AZURE_SCRIPT

# Download clear_storage_config script
sudo wget -O $SETUP_SCRIPTS_LOCATION$CLEAN_STORAGE_SCRIPT $SOURCE_URI$CLEAN_STORAGE_SCRIPT
sudo chmod +x $SETUP_SCRIPTS_LOCATION$CLEAN_STORAGE_SCRIPT

# Download config_azure_jenkins_storage script
sudo wget -O $SETUP_SCRIPTS_LOCATION$CREATE_STORAGE_SCRIPT $SOURCE_URI$CREATE_STORAGE_SCRIPT
sudo chmod +x $SETUP_SCRIPTS_LOCATION$CREATE_STORAGE_SCRIPT

# Download create_service_principal script
sudo wget -O $SETUP_SCRIPTS_LOCATION$CREATE_SERVICE_PRINCIPAL_SCRIPT $SOURCE_URI$CREATE_SERVICE_PRINCIPAL_SCRIPT
sudo chmod +x $SETUP_SCRIPTS_LOCATION$CREATE_SERVICE_PRINCIPAL_SCRIPT

# Download init_jenkins config script
sudo wget -O $SETUP_SCRIPTS_LOCATION$INITIAL_JENKINS_CONFIG $SOURCE_URI$INITIAL_JENKINS_CONFIG
sudo chmod +x $SETUP_SCRIPTS_LOCATION$INITIAL_JENKINS_CONFIG

# Download Jenkins Groovy script
sudo wget -O $SETUP_SCRIPTS_LOCATION$JENKINS_GROOVY $SOURCE_URI$JENKINS_GROOVY

# Download jenkins setup file
sudo wget -O $SETUP_SCRIPTS_LOCATION$JENKINS_JOB $SOURCE_URI$JENKINS_JOB

# Download aptly setup script
sudo wget -O $SETUP_SCRIPTS_LOCATION$APTLY_SCRIPT $SOURCE_URI$APTLY_SCRIPT
sudo chmod +x $SETUP_SCRIPTS_LOCATION$APTLY_SCRIPT

# Delete any existing config script
old_config_storage_file="/opt/azure_jenkins_config/config_storage.sh"
if [ -f $old_config_storage_file ]
then
  sudo rm -f $old_config_storage_file
fi

# Installing git 
sudo apt-get install git -y

# Replace the Oracle username and password in the init script
sudo sed -i "/ORACLE_USER=\"\"/s/ORACLE_USER=\"$ORACLE_USER\"" $SETUP_SCRIPTS_LOCATION$INITIAL_JENKINS_CONFIG
sudo sed -i "/ORACLE_PASSWORD=\"\"/s/ORACLE_PASSWORD=\"$ORACLE_PASSWORD\"" $SETUP_SCRIPTS_LOCATION$INITIAL_JENKINS_CONFIG