# spinnakerhackfest
Jenkins and Spinnaker VM template

This template will allow the automated deployment of Jenkins + Spinnaker in two different VMs in Azure. 
In order to deploy here are the steps to follow: 

1- Create a Service Principal name

2- Create a resource groups
` az resource group create -n testspinnaker11 -l westus

3- Deploy the VMs 
` az resource group deployment create -g testspinnaker11 -n deploy --template-file ./azuredeploy.json --parameters @./azuredeploy.myparams.json

**Note**: the azuredeploy.myparams.json is a copy of the azuredeploy.params.json with your own parameters

4- Unlock Jenkins
Use the initialadminpassword to unlock Jenkins and install the default plugins

5- Initialize Jenkins 
SSH to Jenkins and run the /opt/azure_jenkins_config/