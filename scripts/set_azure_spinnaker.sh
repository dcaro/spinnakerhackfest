#!/bin/bash

# Get azure data 
# clientId : -c 
# AppKey: -a 


while getopts ":t:s:p:c:" opt; do
  case $opt in
    t) TENANTID="$OPTARG"
    ;;
    p) PASSWORD="$OPTARG"
    ;;
    c) CLIENTID="$OPTARG"
    ;;
    s) SUBSCRIPTIONID="$OPTARG"
  esac
done

# Record the Variables for debugging  
sudo touch /tmp/helloworld
sudo printf "Tenant: %s \n" $TENANTID >> /tmp/helloworld
sudo printf "Secret is %s \n" $PASSWORD >> /tmp/helloworld
sudo printf "Client ID %s \n" $CLIENTID >> /tmp/helloworld
sudo printf "Subscription is %s \n" $SUBSCRIPTIONID >> /tmp/helloworld

# Install Spinnaker on the VM
sudo bash -xc "$(curl -s https://raw.githubusercontent.com/spinnaker/spinnaker/master/InstallSpinnaker.sh)"


