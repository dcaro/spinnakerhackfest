#!/bin/bash

# Get Azure Resources Names 
SERVICEPRINCIPALNAME=$1
SUBSCRIPTIONID=$2
OBJECTID=$3
CLIENTID=$4
TENANTID=$5

# Create a test file 
sudo touch /tmp/helloworld
echo $SERVICEPRINCIPALNAME >> /tmp/helloworld 

