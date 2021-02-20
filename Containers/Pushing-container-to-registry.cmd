# Install the Azure command line interface

curl -sL https://packages.microsoft.com/keys/microsoft.asc | \ 
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

AZ_REPO=$(lsb_release -cs)

echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update

sudo apt-get install azure-cli

sudo az login

sudo az acr login --name waynesworldcontainerregistry

sudo docker tag dotnetappnew waynesworldcontainerregistry.azurecr.io/dotnetappnew

sudo docker push waynesworldcontainerregistry.azurecr.io/dotnetappnew

