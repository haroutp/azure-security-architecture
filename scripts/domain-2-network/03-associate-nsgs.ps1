# Associate NSGs with subnets for defense-in-depth security

param(
    [string]$ResourceGroupName = "rg-az500-network",
    [string]$VNetName = "vnet-az500-multitier"
)

Write-Host "Associating NSGs with subnets..." -ForegroundColor Green

# Get VNet and NSGs
$vnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VNetName
$webNsg = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name "nsg-web-subnet"
$appNsg = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name "nsg-app-subnet"  
$dbNsg = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name "nsg-database-subnet"

# Associate NSGs with subnets
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name "WebSubnet" -AddressPrefix "10.0.1.0/24" -NetworkSecurityGroup $webNsg
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name "AppSubnet" -AddressPrefix "10.0.2.0/24" -NetworkSecurityGroup $appNsg
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name "DatabaseSubnet" -AddressPrefix "10.0.3.0/24" -NetworkSecurityGroup $dbNsg

# Apply changes to VNet
$vnet | Set-AzVirtualNetwork

Write-Host "NSG associations complete!" -ForegroundColor Green
Write-Host "Multi-tier network security architecture ready for VM deployment" -ForegroundColor Yellow