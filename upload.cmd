start /B azure storage blob upload -q -f .\azureDeploy.json -b azureDeploy.json --container spinnaker-jenkins -a golivearmstorage -k IEMKYOYJqcy23q2saT1lWcDT/gh0ZUu4ChvYD364obwXSHLf1LU9DRA+89TCfa3zTsQMoGCwk8mxceLoXJP1xQ== -t block
start /B azure storage blob upload -q -f .\azureDeploy.parameters.json -b azureDeploy.parameters.json --container spinnaker-jenkins -a golivearmstorage -k IEMKYOYJqcy23q2saT1lWcDT/gh0ZUu4ChvYD364obwXSHLf1LU9DRA+89TCfa3zTsQMoGCwk8mxceLoXJP1xQ== -t block

start /B azure storage blob upload -q -f .\nested\spinnakerDeploy.json -b nested\spinnakerDeploy.json --container spinnaker-jenkins -a golivearmstorage -k IEMKYOYJqcy23q2saT1lWcDT/gh0ZUu4ChvYD364obwXSHLf1LU9DRA+89TCfa3zTsQMoGCwk8mxceLoXJP1xQ== -t block

start /B azure storage blob upload -q -f .\nested\jenkinsDeploy.json -b nested\jenkinsDeploy.json --container spinnaker-jenkins -a golivearmstorage -k IEMKYOYJqcy23q2saT1lWcDT/gh0ZUu4ChvYD364obwXSHLf1LU9DRA+89TCfa3zTsQMoGCwk8mxceLoXJP1xQ== -t block

start /B azure storage blob upload -q -f .\nested\storageDeploy.json -b nested\storageDeploy.json --container spinnaker-jenkins -a golivearmstorage -k IEMKYOYJqcy23q2saT1lWcDT/gh0ZUu4ChvYD364obwXSHLf1LU9DRA+89TCfa3zTsQMoGCwk8mxceLoXJP1xQ== -t block

start /B azure storage blob upload -q -f .\nested\vnetDeploy.json -b nested\vnetDeploy.json --container spinnaker-jenkins -a golivearmstorage -k IEMKYOYJqcy23q2saT1lWcDT/gh0ZUu4ChvYD364obwXSHLf1LU9DRA+89TCfa3zTsQMoGCwk8mxceLoXJP1xQ== -t block
