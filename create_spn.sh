#!/bin/bash

# Default values 
app_uuid=$(python -c 'import uuid; print str(uuid.uuid4())[:8]')
DISPLAY_NAME="spinnaker"
APPLICATION_NAME="app${app_uuid}"
APPLICATION_URI="{$APPLICATION_NAME}_id"
APPLICATION_KEY=$(python -c 'import uuid; print uuid.uuid4().hex')


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
   SPN_PASSWORD="$2"
   shift
   ;;
   *)

   ;;
esac
shift
done

echo $DISPLAY_NAME
echo $APPLICATION_NAME
echo $APPLICATION_URI
echo $APPLICATION_KEY


my_error_check=$(az ad sp show --search $DISPLAY_NAME --json | grep "displayName" | grep -c \"$DISPLAY_NAME\")
# Check if the application already exists
if [ $my_error_check -gt 0 ];
then
    echo "error application exist"
else
    # Create the application
    my_app=$(az ad app create --display-name=$DISPLAY_NAME --homepage=$APPLICATION_NAME --identifier-uris=$APPLICATION_URI --key-type="Password" --password=$APPLICATION_KEY)

fi

echo $my_app | jq .appId | sed 's/"//g'

# Create the service principal attached
az ad sp create --id= ""

# Do the role assignment 
#az role assignment create --assignee="ae1ff666-4390-425d-a198-d5c96fe67830" --role="Owner" --scope="/subscriptions/0c3a2f71-4128-4509-8719-3b16f291ad5f"
