$accountName = "stagingstore4000"
$filePath = "C:\Users\wschr\OneDrive\Pictures\2021.01-Wayne-kayaking-behind-house\2021.01-Wayne-kayaking-behind-house (9).jpg"
$containerName = "images"

az storage account create --name $accountName --resource-group waynes-azure-test-rg --location EastUS --sku Standard_LRS

az storage container create --account-name $accountName --name $containerName

az storage blob upload --account-name $accountName --container-name $containerName --name kayak07.jpg --file $filePath

az storage container set-permission --account-name $accountName --name $containerName --public-access blob

az storage blob list --account-name $accountName --container-name $containerName --output table

az storage blob download --account-name $accountName --container-name $containerName --name kayak07.jpg --file downloaded-image-07.jpg