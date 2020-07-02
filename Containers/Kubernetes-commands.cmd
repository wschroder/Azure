
# ============================
# Creating Kubernetes Service and cluster

az group create --name kubernetesgrp --location eastus

az aks create --resource-group kubernetesgrp --name democluster --node-count 1 --enable-addons monitoring --generate-ssh-keys

az aks install-cli --install-location =./kubectl

az aks get-credentials --resource-group kubernetesgrp --name democluster

# ============================
# Show all the nodes in this cluster

kubectl get nodes

# Show all running services in this cluster

kubectl get all


# ============================

# Environment variables: Kubernetes service 

$Env:AKS_RESOURCE_GROUP = "kubernetesgrp"
$Env:AKS_CLUSTER_NAME = "democluster"

# Environment variables: constainer registry 

$Env:ACR_RESOURCE_GROUP = "General-admin-RG"
$Env:ACR_NAME = "waynesworldcr"

$Env:CLIENT_ID = $(az aks show --resource-group $Env:AKS_RESOURCE_GROUP --name $Env:AKS_CLUSTER_NAME --query "servicePrincipalProfile.clientId" --output tsv)

echo $Env:CLIENT_ID

$Env:ACR_ID=$(az acr show --name $Env:ACR_NAME --resource-group $Env:ACR_RESOURCE_GROUP --query "id" --output tsv)

az role assignment create --assignee $Env:CLIENT_ID --role acrpull --scope $Env:ACR_ID
