$rg = "managed-identity-rg"
$loc = "EAST US"

# New-AzResourceGroup -Name $rgName -Location $loc

$vm = "dev-gfc-"

New-AzVm `
    -ResourceGroupName $rg `
    -Name "myVM" `
    -Location "East US" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -OpenPorts 80,3389
