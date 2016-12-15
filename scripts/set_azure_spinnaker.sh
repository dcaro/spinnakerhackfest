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

# Record the Variables in text file for debugging purposes  
sudo touch /tmp/helloworld
sudo printf "Tenant: %s \n" $TENANTID > /tmp/helloworld
sudo printf "Secret is %s \n" $PASSWORD >> /tmp/helloworld
sudo printf "Client ID %s \n" $CLIENTID >> /tmp/helloworld
sudo printf "Subscription is %s \n" $SUBSCRIPTIONID >> /tmp/helloworld
sudo printf "Packer Resource Groups is %s \n" $PACKERRESOURCEGROUP >> /tmp/helloworld
sudo printf "Packer Storage Account is %s \n" $PACKERSTORAGEACCOUNT >> /tmp/helloworld
sudo printf "Default Resource Group %s \n" $RESOURCEGROUP >> /tmp/helloworld
sudo printf "Key Vault %s \n" $KEYVAULT >> /tmp/helloworld

sudo touch /tmp/debug
sudo printf "working directory is %s\n" $WORKDIR >> /tmp/debug

sudo printf "Upgrading the environment \n" >> /tmp/debug
# Update and upgrade packages
sudo rm /var/lib/dpkg/updates/*
sudo printf "directory /var/lib/dpkg/updates removed \n" >> /tmp/debug
sudo apt-get update -y
sudo printf "apt-get update completed \n" >> /tmp/debug
# sudo apt-get upgrade -y
# sudo printf "apt-get upgrade completed \n" >> /tmp/debug

# Install Spinnaker on the VM
sudo printf "Starting to install Spinnaker\n" >> /tmp/debug
sudo printf "azure\nwestus\n" > /tmp/spinnaker.inputs
sudo bash -xc "$(curl -s https://raw.githubusercontent.com/spinnaker/spinnaker/master/InstallSpinnaker.sh)" < /tmp/spinnaker.inputs 
sudo printf "Spinnaked has been installed\n" >> /tmp/debug

sudo apt-get update
sudo apt-get upgrade spinnaker
sudo printf "updating spinnaker \n" >> /tmp/debug

# Configuring the /opt/spinnaker/config/default-spinnaker-local.yml
# Let's create the sed command file and run the sed command

sudo printf "Setting up sedCommand \n" >> /tmp/debug

sudo printf "s/enabled: ${SPINNAKER_AZURE_ENABLED:false}/enabled: ${SPINNAKER_AZURE_ENABLED:true}/\n" > /tmp/sedCommand.sed
sudo printf "s/clientId:$/& %s/\n" $CLIENTID >> /tmp/sedCommand.sed
sudo printf "s/appKey:$/& %s/\n" $PASSWORD >> /tmp/sedCommand.sed
sudo printf "s/tenantId:$/& %s/\n" $TENANTID >> /tmp/sedCommand.sed
sudo printf "s/subscriptionId:$/& %s/\n" $SUBSCRIPTIONID >> /tmp/sedCommand.sed
# Adding the PackerResourceGroup, the PackerStorageAccount, the defaultResourceGroup and the defaultKeyVault  
sudo printf "/subscriptionId:/a\      packerResourceGroup: %s\n      packerStorageAccount: %s\n      defaultResourceGroup: %s\n      defaultKeyVault: %s\n" $PACKERRESOURCEGROUP $PACKERSTORAGEACCOUNT $RESOURCEGROUP $KEYVAULT >> /tmp/sedCommand.sed
sudo printf "sedCommand.sed file created\n" >> /tmp/debug

sudo sed -i -f sedCommand.sed /opt/spinnaker/config/spinnaker-local.yml  

sudo printf "spinnaker-local.yml file has been updated\n" >> /tmp/debug

# Configure rosco.yaml file  
sudo sed '/^# debianRepository:/s/.*/debianRepository: '$STDDR':'$BINTRAY'/'  /opt/rosco/config/rosco.yml
sudo sed '/defaultCloudProviderType/s/.*/defaultCloudProviderType: azure/' /opt/rosco/config/rosco.yml

sudo printf "rosco.yml file has been updated\n" >> /tmp/debug