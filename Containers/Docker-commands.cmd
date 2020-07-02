{image-name} = waynesworldcr.azurecr.io/demowebapp

# ============================
# To login to container registry in Azure

az login

# az acr login --name waynesworldcr

docker login waynesworldcr.azurecr.io -u waynesworldcr
# pVggXaHlICmDoIa/rlTJOifdvwdb60Dp

# ============================
# To push up an image 

docker tag {image-name} waynesworldcr.azurecr.io/{image-name}
docker push waynesworldcr.azurecr.io/{image-name}


# ============================
# To pull down an image 

docker pull waynesworldcr.azurecr.io/{image-name}

# ============================
# To run an image 

docker run -it --rm -p 5100:5000 {image-name}

