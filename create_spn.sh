#!/bin/bash

# Add jq
# sudo apt-get install jq -y 

# Default values 
app_uuid=$(python -c 'import uuid; print str(uuid.uuid4())[:8]')
DISPLAY_NAME="spinnaker"
APPLICATION_NAME="app${app_uuid}"
APPLICATION_URI="${APPLICATION_NAME}_id"
APPLICATION_KEY=$(python -c 'import uuid; print uuid.uuid4().hex')
TENANT_ID=""
SUBSCRIPTION_NAME="Dev Ops_events_dcaro"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
   -d)
   DISPLAY_NAME="$2"
   shift
   ;;
   -h)
   APPLICATION_HOME="$2"
   shift
   ;;
   -u)
   APPLICATION_URI="$2"
   shift
   ;;
   -p)
   APPLICATION_KEY="$2"
   shift
   ;;
   -t)
   TENANT_ID="$2"
   shift
   ;;
   -n)
   SUBSCRIPTION_NAME="$2"
   shift
   ;;
   *)

   ;;
esac
shift
done

echo "Debug information:"
echo "Tenant Id: "$TENANT_ID
echo "Display Name: "$DISPLAY_NAME
echo "Application Name: "$APPLICATION_NAME
echo "Application Uri: "$APPLICATION_URI
echo "Application Key: "$APPLICATION_KEY

# Obtain the tenantId of the subscriptions
if [ -z "$TENANT_ID" ] 
then
    AZURE_ACCOUNT=$(az account show --subscription "$SUBSCRIPTION_NAME")
    echo $AZURE_ACCOUNT
    TENANT_ID=$(echo $AZURE_ACCOUNT | jq .tenantId | sed 's/"//g')
    echo $TENANT_ID
fi 


# Create the application

# Check if the application already exist
my_error_check=$(az ad app list --filter "identifierUris/any(identifierUris: identifierUris eq '$APPLICATION_URI')" | jq '. | length')

if [ $my_error_check > 0 ];
then
    echo "An application already exist with this identifer-uri: $APPLICATION_URI"
    echo "We will use that application"
else
    # Create the application 
    AZAD_APP=$(az ad app create --display-name="$DISPLAY_NAME" --homepage="http://$APPLICATION_NAME" --identifier-uris="http://$APPLICATION_URI" --key-type="Password" --password="$APPLICATION_KEY")
    echo $AZAD_APP
    echo "Waiting for the creation of the app"
    sleep 5 
    #  Verify if the application has been created
    ###### Add the code to verify if the app has been created 
fi

    #APP_ID=$(echo $AZAD_APP | jq .appId | sed 's/"//g')
    APP_ID=$(az ad app list --filter "identifierUris/any(identifierUris: identifierUris eq 'http://$APPLICATION_URI')" | jq -r '.[0].appId')
    echo "Application ID is: $APP_ID"
    if [ $APP_ID = '' ];
    then 
        echo "Application not created"
    else
        # We can create the SPN 
        error_check=$(az ad sp list --filter "servicePrincipalNames/any(servicePrincipalNames: servicePrincipalNames eq 'http://$APPLICATION_URI')")
        if [ $error_check -gt 0 ];
        then 
            SPN=$(az ad sp create --id="$APP_ID")
            echo $SPN
        fi
    fi




# Do the role assignment 

az role assignment create --assignee="ae1ff666-4390-425d-a198-d5c96fe67830" --role="Owner" --scope="/subscriptions/0c3a2f71-4128-4509-8719-3b16f291ad5f"
