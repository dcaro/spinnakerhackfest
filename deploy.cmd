call azure group create goliveSpinRg%1 -l westus

powershell -c .\UpdateIndex.ps1 -newIndex %1

call azure group deployment create -g goliveSpinRg%1 -f .\azureDeploy.json -e .\azureDeploy.parameters.json -v

