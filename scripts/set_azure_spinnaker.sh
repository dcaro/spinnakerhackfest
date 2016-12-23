#!/bin/bash

# Get azure data 
# clientId : -c 
# AppKey: -a 


while getopts ":t:s:p:c:g:h:r:k:b:" opt; do
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
  esac
done

export BINTRAY='http:\/\/dl.bintray.com\/richardguthrie\/rguthrie-spinnaker_trusty_release'
export STDDR='http:\/\/ppa.launchpad.net\/openjdk-r\/ppa\/ubuntu_trusty_main'
export WORKDIR=$(pwd)
export JENKINS_URL='http:\/\/myjenkins.westus.azure.com:8080'
export JENKINS_USERNAME='jenkins'
export JENKINS_PASSWORD='P@ssw0rd'

# Record the Variables in text file for debugging purposes  
sudo touch /tmp/helloworld
sudo printf "TENANTID=%s\n" $TENANTID > /tmp/helloworld
sudo printf "PASSWORD=%s\n" $PASSWORD >> /tmp/helloworld
sudo printf "CLIENTID=%s\n" $CLIENTID >> /tmp/helloworld
sudo printf "SUBSCRIPTIONID=%s\n" $SUBSCRIPTIONID >> /tmp/helloworld
sudo printf "PACKERRESOURCEGROUP=%s\n" $PACKERRESOURCEGROUP >> /tmp/helloworld
sudo printf "PACKERSTORAGEACCOUNT=%s\n" $PACKERSTORAGEACCOUNT >> /tmp/helloworld
sudo printf "RESOURCEGROUP=%s\n" $RESOURCEGROUP >> /tmp/helloworld
sudo printf "KEYVAULT=%s\n" $KEYVAULT >> /tmp/helloworld

sudo touch /tmp/debug
sudo printf "working directory is %s\n" $WORKDIR >> /tmp/debug

sudo printf "Upgrading the environment\n" >> /tmp/debug
# Update and upgrade packages
sudo apt-mark hold walinuxagent grub-legacy-ec2
sudo printf "Holding walinuxagent\n" >> /tmp/debug
sudo apt-get update -y
sudo printf "apt-get update completed\n" >> /tmp/debug
sudo rm /var/lib/dpkg/updates/*
sudo printf "directory /var/lib/dpkg/updates removed\n" >> /tmp/debug
sudo apt-get upgrade -y
sudo printf "apt-get upgrade completed\n" >> /tmp/debug

# Install Spinnaker on the VM
sudo printf "Starting to install Spinnaker\n" >> /tmp/debug
sudo printf "azure\nwestus\n" > /tmp/spinnaker.inputs
sudo bash -xc "$(curl -s https://raw.githubusercontent.com/spinnaker/spinnaker/master/InstallSpinnaker.sh)" < /tmp/spinnaker.inputs 
sudo printf "Spinnaked has been installed\n" >> /tmp/debug

# Refresh Spinnaker installation
# sudo apt-mark hold waagent
# sudo apt-get update -y
# sudo apt-get upgrade spinnaker -y
# sudo printf "updating spinnaker \n" >> /tmp/debug
# sudo apt-mark unhold waagent

# Configuring the /opt/spinnaker/config/default-spinnaker-local.yml
# Let's create the sed command file and run the sed command

sudo printf "Setting up sedCommand \n" >> /tmp/debug

sudo printf "s/enabled: ${SPINNAKER_AZURE_ENABLED:false}/enabled: ${SPINNAKER_AZURE_ENABLED:true}/g\n" > /tmp/sedCommand.sed
sudo printf "s/clientId:$/& %s/\n" $CLIENTID >> /tmp/sedCommand.sed
sudo printf "s/appKey:$/& %s/\n" $PASSWORD >> /tmp/sedCommand.sed
sudo printf "s/tenantId:$/& %s/\n" $TENANTID >> /tmp/sedCommand.sed
sudo printf "s/subscriptionId:$/& %s/\n" $SUBSCRIPTIONID >> /tmp/sedCommand.sed
# Adding the PackerResourceGroup, the PackerStorageAccount, the defaultResourceGroup and the defaultKeyVault  
sudo printf "s/packerResourceGroup:$/& %s/\n" $PACKERRESOURCEGROUP >> /tmp/sedCommand.sed
sudo printf "s/packerStorageAccount:$/& %s/\n" $PACKERSTORAGEACCOUNT >> /tmp/sedCommand.sed
sudo printf "s/defaultResourceGroup:$/& %s/\n" $RESOURCEGROUP >> /tmp/sedCommand.sed
sudo printf "s/defaultKeyVault:$/& %s/\n" $KEYVAULT >> /tmp/sedCommand.sed

# Enable Igor for the integration with Jenkins
sudo printf "/igor:/ {\n           N\n           N\n           N\n           /enabled:/ {\n             s/enabled:.*/enabled: true/\n             P\n             D\n         }\n}\n" >> /tmp/sedCommand.sed

# Configure the Jenkins instance
sudo printf "/name: Jenkins.*/ {\n N\n /baseUrl:/ { s/baseUrl:.*/baseUrl: %s/ }\n" $JENKINS_URL >> /tmp/sedCommand.sed
sudo printf " N\n /username:/ { s/username:/username: %s/ }\n" $JENKINS_USERNAME >> /tmp/sedCommand.sed
sudo printf " N\n /password:/ { s/password:/password: %s/ }\n" $JENKINS_PASSWORD >> /tmp/sedCommand.sed
sudo printf "}" >> /tmp/sedCommand.sed

sudo printf "sedCommand.sed file created\n" >> /tmp/debug

# Set the variables in the spinnaker-local.yml file
sudo sed -i -f /tmp/sedCommand.sed /opt/spinnaker/config/spinnaker-local.yml 
sudo printf "spinnaker-local.yml file has been updated\n" >> /tmp/debug

# Configure rosco.yml file  
sudo sed -i '/^# debianRepository:/s/.*/debianRepository: '$STDDR':'$BINTRAY'/' /opt/rosco/config/rosco.yml
sudo sed -i '/defaultCloudProviderType/s/.*/defaultCloudProviderType: azure/' /opt/rosco/config/rosco.yml
sudo printf "rosco.yml file has been updated\n" >> /tmp/debug

# Adding apt-key key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB9B1D8886F44E2A
sudo printf "apt-key done\n" >> /tmp/debug

# rebooting the VM to avoid issues with front50
sudo printf "Rebooting the system after installation\n" >> /tmp/debug
sudo shutdown -r now "Rebooting the system after Spinnaker installation"
