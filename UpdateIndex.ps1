param (
    [string]$newIndex = "00"
)

$customObject = Get-Content -Raw -Path C:\github\Sandbox\Spinnaker-Jenkins\azureDeploy.parameters.json | ConvertFrom-Json
$customObject.parameters.resourceIndex.value = $newIndex
$newFileContent = ConvertTo-Json -InputObject $customObject
Set-Content -Path C:\github\Sandbox\Spinnaker-Jenkins\azureDeploy.parameters.json -Value $newFileContent

