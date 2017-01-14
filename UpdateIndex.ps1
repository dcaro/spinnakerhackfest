param (
    [string]$newIndex = "00"
)

$customObject = Get-Content -Raw -Path .\azureDeploy.parameters.json | ConvertFrom-Json
$customObject.parameters.resourceIndex.value = $newIndex
$newFileContent = ConvertTo-Json -InputObject $customObject
Set-Content -Path .\azureDeploy.parameters.json -Value $newFileContent

