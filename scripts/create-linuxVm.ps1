# prerequisites
Install-Module -Name Az -AllowClobber -Scope CurrentUser

# connect to Azure
# Connect-AzAccount
# Select-AzSubscription "<YOUR_SUBSCRIPTION_ID>"

$adminName = Read-Host -Prompt "Admin user"
$securePassword = Read-Host -Prompt "Password" -AsSecureString

# create VMs
$vmName = "myVM1"
$ip = "10.11.11.11"
$rg = "managed-identity-rg"
$loc = "EAST US"

$vnet = Get-AzVirtualNetwork `
            -Name $rg `
            -ResourceGroupName $rg

$subnet = Get-AzVirtualNetworkSubnetConfig `
            -Name $subnet.Name `
            -VirtualNetwork $vnet

$pip = New-AzPublicIpAddress `
            -Name "$vmName-pip" `
            -ResourceGroupName $rg `
            -Location $loc `
            -AllocationMethod Dynamic `
            -IdleTimeoutInMinutes 4

$nsg_ssh = New-AzNetworkSecurityRuleConfig `
              -Name "ssh" `
              -Protocol "Tcp" `
              -Direction "Inbound"  `
              -Priority 300  `
              -SourceAddressPrefix *  `
              -SourcePortRange *  `
              -DestinationAddressPrefix *  `
              -DestinationPortRange 22  `
              -Access "Allow"

$nsg_web = New-AzNetworkSecurityRuleConfig  `
              -Name "web"  `
              -Protocol "Tcp"  `
              -Direction "Inbound"  `
              -Priority 301  `
              -SourceAddressPrefix *  `
              -SourcePortRange *  `
              -DestinationAddressPrefix *  `
              -DestinationPortRange 80  `
              -Access "Allow"

$nsg = New-AzNetworkSecurityGroup  `
              -Name "$vmName-nsg"  `
              -ResourceGroupName $rg  `
              -Location $loc `
              -SecurityRules $nsg_ssh,$nsg_web

$ipNotExists = Test-AzPrivateIPAddressAvailability  `
                -IPAddress $ip  `
                -ResourceGroupName $rg  `
                -VirtualNetworkName $vnet.Name

if($true -eq $ipNotExists) {

    $ipconfig = New-AzNetworkInterfaceIpConfig  `
                -Name "$vmName-ip"  `
                -Subnet $subnet  `
                -PrivateIpAddress $ip  `
                -PublicIpAddress $pip

    $nic = New-AzNetworkInterface  `
                -Name "$vmName-nic"  `
                -ResourceGroupName $rg  `
                -Location $loc  `
                -IpConfiguration $ipconfig  `
                -NetworkSecurityGroupId $nsg.Id
}

$cred = New-Object System.Management.Automation.PSCredential ($adminName, $securePassword)

$vmConfig = New-AzVMConfig  `
              -VMName $vmName  `
              -VMSize "Standard_A1_v2"  `
          | Set-AzVMOperatingSystem  `
              -Linux  `
              -ComputerName $vmName  `
              -Credential $cred  `
              -DisablePasswordAuthentication  `
          | Set-AzVMSourceImage  `
              -PublisherName "Canonical"  `
              -Offer "UbuntuServer"  `
              -Skus "18.10"  `
              -Version "latest"  `
          | Add-AzVMNetworkInterface -Id $nic.Id

$sshPublicKey = cat ~/.ssh/id_rsa.pub

Add-AzVMSshPublicKey  `
              -VM $vmconfig  `
              -KeyData $sshPublicKey  `
              -Path "/home/tomica/.ssh/authorized_keys"

New-AzVM -ResourceGroupName $rg  `
              -Location $loc  `
              -VM $vmConfig
