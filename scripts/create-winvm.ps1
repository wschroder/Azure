$location = "EAST US"
$rgName = "managed-identity-rg"
$computerName = "internal-vm-id-01"
$vmName = "vm-01"
$vmSize = "Standard_DS3"

$networkName = "managed-identity-vnet"
$NICName = "nic1"
$subnetName = "managed-identity-subnet"
$subnetAddressPrefix = "10.0.0.0/24"
$vnetAddressPrefix = "10.0.0.0/16"

$adminUser = Read-Host -Prompt "Admin user"
$adminPassword = Read-host -Prompt "Password" -AsSecureString

$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddressPrefix
$Vnet = New-AzVirtualNetwork -Name $networkName -ResourceGroupName $rgName -Location $location -AddressPrefix $vnetAddressPrefix -Subnet $subnet
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $rgName -Location $location -SubnetId $Vnet.Subnets[0].Id

$Credential = New-Object System.Management.Automation.PSCredential ($adminUser, $adminPassword);

$vm = New-AzVMConfig -VMName $vmName -VMSize $vmSize
$vm = Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName $computerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$vm = Add-AzVMNetworkInterface -VM $vm -Id $NIC.Id
$vm = Set-AzVMSourceImage -VM $vm -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2012-R2-Datacenter' -Version latest

New-AzVM -ResourceGroupName $rgName -Location $location -VM $vm -Verbose