# Manually run Add-AzureAccount (and possibly Connect-AzAccount) before running this script, to establish account access

$configFile = "AzureConfig.json"

if ($false -eq (Test-Path -Path $configFile -PathType Leaf) ) {
    Write-Host "Required config file [$($configFile)] not found." -Foreground Red
    exit
}

$config = get-content $configFile | ConvertFrom-Json

# $config.StorageAccount.Name
# $config.StorageAccount.ResourceGroup

$storageAccount = Get-AzStorageAccount `
                -Name $config.StorageAccount.Name `
                -ResourceGroupName $config.StorageAccount.ResourceGroup `
                -errorAction:SilentlyContinue `
                -errorVariable errorInfo

if ($errorInfo) {
    Write-Host $errorInfo.Exception.Message -Foreground Red
    exit
}

Write-Host "Storage account found: $($storageAccount.StorageAccountName)"  

$containers = Get-AzRmStorageContainer  -StorageAccountName $config.StorageAccount.Name `
                                        -ResourceGroupName $config.StorageAccount.ResourceGroup

Write-Host "Containers: "

foreach($c in $containers) {
    Write-Host "  $($c.Name)"
}                                        