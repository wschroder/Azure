<#
    Sample header. 
#>

$location = "EAST US"
$rgName = "managed-identity-rg"
$computerName = "gfc-vm208"
$vmName = "$computerName-vm"
$vmSize = "Standard_DS3"

$networkName = "managed-identity-vnet"
$NICName = "nic1"
$subnetName = "managed-identity-subnet"
$subnetAddressPrefix = "10.0.0.0/24"
$vnetAddressPrefix = "10.0.0.0/16"

function CreateNetworkSecurityGroup {
    Param(
        [string] $Name
    )

    $rule1 = New-AzNetworkSecurityRuleConfig `
        -Name rdp-rule `
        -Description "Allow RDP" `
        -Access Allow `
        -Protocol Tcp `
        -Direction Inbound `
        -Priority 100 `
        -SourceAddressPrefix  Internet `
        -SourcePortRange * `
        -DestinationAddressPrefix * `
        -DestinationPortRange 3389

    $rule2 = New-AzNetworkSecurityRuleConfig `
        -Name web-rule `
        -Description "Allow HTTP" `
        -Access Allow `
        -Protocol Tcp `
        -Direction Inbound `
        -Priority 101 `
        -SourceAddressPrefix Internet `
        -SourcePortRange * `
        -DestinationAddressPrefix * `
        -DestinationPortRange 80

    $nsg = New-AzNetworkSecurityGroup `
        -Name $Name `
        -ResourceGroupName $rgName `
        -Location $location `
        -SecurityRules $rule1,$rule2

    return $nsg    
}

$adminUser = Read-Host -Prompt "Admin user"
if ("admin" -eq $adminUser) {
    throw "'admin' is an invalid user id."
}
$adminPassword = Read-host -Prompt "Password" -AsSecureString

$nsg = CreateNetworkSecurityGroup -Name "nsg01"

$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddressPrefix
$Vnet = New-AzVirtualNetwork -Name $networkName -ResourceGroupName $rgName -Location $location -AddressPrefix $vnetAddressPrefix -Subnet $subnet
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $rgName -Location $location -SubnetId $Vnet.Subnets[0].Id

$NIC.NetworkSecurityGroup = $nsg
$NIC | Set-AzNetworkInterface

$Credential = New-Object System.Management.Automation.PSCredential ($adminUser, $adminPassword);

$vm = New-AzVMConfig -VMName $vmName -VMSize $vmSize
$vm = Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName $computerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$vm = Add-AzVMNetworkInterface -VM $vm -Id $NIC.Id
$vm = Set-AzVMSourceImage -VM $vm -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2012-R2-Datacenter' -Version latest

New-AzVM -ResourceGroupName $rgName -Location $location -VM $vm -Verbose
