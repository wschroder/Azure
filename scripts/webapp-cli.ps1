$gitRepo = "https://github.com/wschroder/Azure.git"
$rg = "appservice2-rg"
$loc = "eastus"
$plan = "newappplan2000"
$sku = "B1"
$webApp = "waynesmasterapp01"
$branch = "master"

az group create --location $loc `
                --name $rg

az appservice plan create --name $plan `
                          --resource-group $rg `
                          --sku $sku

az webapp create --name $webApp `
                 --resource-group $rg  `
                 --plan $plan

az webapp deployment source config `
                --name $webApp `
                --resource-group $rg `
                --repo-url $gitRepo `
                --branch $branch `
                --manual-integration
