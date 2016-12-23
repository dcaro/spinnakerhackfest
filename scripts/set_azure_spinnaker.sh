#!/bin/bash

# Get azure data 
# clientId : -c 
# AppKey: -a 


while getopts ":t:s:p:c:g:h:r:k:b:j:u:q:" opt; do
  case $opt in
    t) TENANTID="$OPTARG"
    ;;
    p) PASSWORD="$OPTARG"
    ;;
    c) CLIENTID="$OPTARG"
    ;;
    s) SUBSCRIPTIONID="$OPTARG"
    ;;
    g) PACKERRESOURCEGROUP="$OPTARG"
    ;;
    h) PACKERSTORAGEACCOUNT="$OPTARG"
    ;;
    r) RESOURCEGROUP="$OPTARG"
    ;;
    k) KEYVAULT="$OPTARG"
    ;;
    b) BINTRAY="$OPTARG"
    ;;
    j) JENKINS_URL="$OPTARG"
    ;;
    u) JENKINS_USERNAME="$OPTARG"
    ;;
    q) JENKINS_PASSWORD="$OPTARG"
    ;;
  esac
done

DEBUG_FILE="/tmp/debugfile"
SED_FILE="$SED_FILE"
BINTRAY='http:\/\/dl.bintray.com\/richardguthrie\/rguthrie-spinnaker_trusty_release'
STDDR='http:\/\/ppa.launchpad.net\/openjdk-r\/ppa\/ubuntu_trusty_main'
WORKDIR=$(pwd)
JENKINS_URL='http:\/\/myjenkins.westus.azure.com:8080'
JENKINS_USERNAME='jenkins'
JENKINS_PASSWORD='P@ssw0rd'

# Record the Variables in text file for debugging purposes  
sudo touch $DEBUG_FILE
sudo printf "TENANTID=%s\n" $TENANTID > $DEBUG_FILE
sudo printf "PASSWORD=%s\n" $PASSWORD >> $DEBUG_FILE
sudo printf "CLIENTID=%s\n" $CLIENTID >> $DEBUG_FILE
sudo printf "SUBSCRIPTIONID=%s\n" $SUBSCRIPTIONID >> $DEBUG_FILE
sudo printf "PACKERRESOURCEGROUP=%s\n" $PACKERRESOURCEGROUP >> $DEBUG_FILE
sudo printf "PACKERSTORAGEACCOUNT=%s\n" $PACKERSTORAGEACCOUNT >> $DEBUG_FILE
sudo printf "RESOURCEGROUP=%s\n" $RESOURCEGROUP >> $DEBUG_FILE
sudo printf "KEYVAULT=%s\n" $KEYVAULT >> $DEBUG_FILE
sudo printf "JENKINS_URL=%s\n" $JENKINS_URL >> $DEBUG_FILE

sudo printf "working directory is %s\n" $WORKDIR >> $DEBUG_FILE

sudo printf "Upgrading the environment\n" >> $DEBUG_FILE
# Update and upgrade packages
sudo apt-mark hold walinuxagent grub-legacy-ec2
sudo printf "Holding walinuxagent\n" >> $DEBUG_FILE
sudo apt-get update -y
sudo printf "apt-get update completed\n" >> $DEBUG_FILE
sudo rm /var/lib/dpkg/updates/*
sudo printf "directory /var/lib/dpkg/updates removed\n" >> $DEBUG_FILE
sudo apt-get upgrade -y
sudo printf "apt-get upgrade completed\n" >> $DEBUG_FILE

# Install Spinnaker on the VM
sudo printf "Starting to install Spinnaker\n" >> $DEBUG_FILE
sudo printf "azure\nwestus\n" > /tmp/spinnaker.inputs
sudo bash -xc "$(curl -s https://raw.githubusercontent.com/spinnaker/spinnaker/master/InstallSpinnaker.sh)" < /tmp/spinnaker.inputs 
sudo printf "Spinnaked has been installed\n" >> $DEBUG_FILE

# Refresh Spinnaker installation
# sudo apt-mark hold waagent
# sudo apt-get update -y
# sudo apt-get upgrade spinnaker -y
# sudo printf "updating spinnaker \n" >> $DEBUG_FILE
# sudo apt-mark unhold waagent

# Configuring the /opt/spinnaker/config/default-spinnaker-local.yml
# Let's create the sed command file and run the sed command

sudo printf "Setting up sedCommand \n" >> $DEBUG_FILE

sudo printf "s/enabled: ${SPINNAKER_AZURE_ENABLED:false}/enabled: ${SPINNAKER_AZURE_ENABLED:true}/g\n" > $SED_FILE
sudo printf "s/clientId:$/& %s/\n" $CLIENTID >> $SED_FILE
sudo printf "s/appKey:$/& %s/\n" $PASSWORD >> $SED_FILE
sudo printf "s/tenantId:$/& %s/\n" $TENANTID >> $SED_FILE
sudo printf "s/subscriptionId:$/& %s/\n" $SUBSCRIPTIONID >> $SED_FILE
# Adding the PackerResourceGroup, the PackerStorageAccount, the defaultResourceGroup and the defaultKeyVault  
sudo printf "s/packerResourceGroup:$/& %s/\n" $PACKERRESOURCEGROUP >> $SED_FILE
sudo printf "s/packerStorageAccount:$/& %s/\n" $PACKERSTORAGEACCOUNT >> $SED_FILE
sudo printf "s/defaultResourceGroup:$/& %s/\n" $RESOURCEGROUP >> $SED_FILE
sudo printf "s/defaultKeyVault:$/& %s/\n" $KEYVAULT >> $SED_FILE

# Enable Igor for the integration with Jenkins
sudo printf "/igor:/ {\n           N\n           N\n           N\n           /enabled:/ {\n             s/enabled:.*/enabled: true/\n             P\n             D\n         }\n}\n" >> $SED_FILE

# Configure the Jenkins instance
sudo printf "/name: Jenkins.*/ {\n N\n /baseUrl:/ { s/baseUrl:.*/baseUrl: %s/ }\n" $JENKINS_URL >> $SED_FILE
sudo printf " N\n /username:/ { s/username:/username: %s/ }\n" $JENKINS_USERNAME >> $SED_FILE
sudo printf " N\n /password:/ { s/password:/password: %s/ }\n" $JENKINS_PASSWORD >> $SED_FILE
sudo printf "}" >> $SED_FILE

sudo printf "sedCommand.sed file created\n" >> $DEBUG_FILE

# Set the variables in the spinnaker-local.yml file
sudo sed -i -f $SED_FILE /opt/spinnaker/config/spinnaker-local.yml 
sudo printf "spinnaker-local.yml file has been updated\n" >> $DEBUG_FILE

# Configure rosco.yml file  
sudo sed -i '/^# debianRepository:/s/.*/debianRepository: '$STDDR':'$BINTRAY'/' /opt/rosco/config/rosco.yml
sudo sed -i '/defaultCloudProviderType/s/.*/defaultCloudProviderType: azure/' /opt/rosco/config/rosco.yml
sudo printf "rosco.yml file has been updated\n" >> $DEBUG_FILE

# Adding apt-key key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB9B1D8886F44E2A
sudo printf "apt-key done\n" >> $DEBUG_FILE

# rebooting the VM to avoid issues with front50
sudo printf "Rebooting the system after installation\n" >> $DEBUG_FILE
sudo shutdown -r +2 "Rebooting the system after Spinnaker installation" &

