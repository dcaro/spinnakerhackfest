# spinnakerhackfest
Jenkins and Spinnaker VM template

This template will allow the automated deployment of Jenkins + Spinnaker in two different VMs in Azure.  This guide uses the Azure-Cli 2.0.  Instructions to install/update to the latest version can be found [here](https://docs.microsoft.com/en-us/cli/azure/install-az-cli2).
 
In order to deploy here are the steps to follow: 

1- Create a Service Principal name
  A. Using the az cli, login to your subscription.
  B. Run the script ./create_spn.sh passing in the name of your subscription as a parameter (-n parameter).  See script for usage documentation regarding optional parameters.

2- Create a resource groups

  `` az group create -n testspinnaker11 -l westus `` 

3- Deploy the VMs 

 `` az group deployment create -g testspinnaker11 -n deploy --template-file ./azuredeploy.json --parameters @./azuredeploy.myparams.json `` 

**Note**: the azuredeploy.myparams.json is a copy of the azuredeploy.params.json with your own parameters

4- Unlock Jenkins

SSH to the JenkinsVM and open he /var/lib/jenkins/secrets/initialadminpassword to unlock Jenkins, install the default plugins and create a jenkins user with the same parameters than the ones entered at the deployment of the VM.

5- Initialize Jenkins 

SSH to Jenkins and run the following command: 

  ``/opt/azure_jenkins_config/init_jenkins.sh `` 

6- Open an ssh tunnel to you spinnaker host and access http://localhost:9000

