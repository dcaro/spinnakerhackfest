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

# Install Spinnaker on the VM
sudo bash -xc "$(curl -s https://raw.githubusercontent.com/spinnaker/spinnaker/master/InstallSpinnaker.sh)"

# Update and upgrade packages
sudo apt-get update -y && sudo apt-get upgrade spinnaker -y

# Configuring the /opt/spinnaker/config/default-spinnaker-local.yml
# Let's create the sed command file and run the sed command
 
echo 's/enabled: ${SPINNAKER_AZURE_ENABLED:false}/enabled: ${SPINNAKER_AZURE_ENABLED:true}/' > sedCommand.sed
echo 's/clientId:$/& '$CLIENTID'/' >> sedCommand.sed
echo 's/appKey:$/& '$PASSWORD'/' >> sedCommand.sed
echo 's/tenantId:$/& '$TENANTID'/' >> sedCommand.sed
echo 's/subscriptionId:$/& '$SUBSCRIPTIONID'/' >> sedCommand.sed
# Adding the PackerResourceGroup, the PackerStorageAccount, the defaultResourceGroup and the defaultKeyVault  
echo '/subscriptionId:/a\      packerResourceGroup: '$PACKERRESOURCEGROUP'\n      packerStorageAccount: '$PACKERSTORAGEACCOUNT'\n      defaultResourceGroup: '$RESOURCEGROUP'\n      defaultKeyVault: '$KEYVAULT'' >> sedCommand.sed

sudo sed -i -f sedCommand.sed /opt/spinnaker/config/default-spinnaker-local.yml  

# Configure rosco.yaml file  
sudo sed '/^# debianRepository:/s/.*/debianRepository: '$STDDR':'$BINTRAY'/'  /opt/rosco/config/rosco.yml
sudo sed '/defaultCloudProviderType/s/.*/defaultCloudProviderType: azure/' /opt/rosco/config/rosco.yml
