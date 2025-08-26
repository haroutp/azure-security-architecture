# AZ-500 Lab: Domain 2 - Multi-Tier Network Security Architecture
# Creates VNet with three-tier segmentation and NSG security controls

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName = "rg-az500-network",
    [string]$Location = "East US",
    [string]$VNetName = "vnet-az500-multitier"
)

Write-Host "Creating multi-tier network architecture..." -ForegroundColor Green

# Create resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force

# Create subnets configuration
$webSubnet = New-AzVirtualNetworkSubnetConfig -Name "WebSubnet" -AddressPrefix "10.0.1.0/24"
$appSubnet = New-AzVirtualNetworkSubnetConfig -Name "AppSubnet" -AddressPrefix "10.0.2.0/24" 
$dbSubnet = New-AzVirtualNetworkSubnetConfig -Name "DatabaseSubnet" -AddressPrefix "10.0.3.0/24"

# Create VNet with three-tier architecture
$vnet = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VNetName -AddressPrefix "10.0.0.0/16" -Subnet $webSubnet, $appSubnet, $dbSubnet

Write-Host "VNet '$VNetName' created with three-tier architecture" -ForegroundColor Yellow
Write-Host "- WebSubnet: 10.0.1.0/24" -ForegroundColor Cyan
Write-Host "- AppSubnet: 10.0.2.0/24" -ForegroundColor Cyan  
Write-Host "- DatabaseSubnet: 10.0.3.0/24" -ForegroundColor Cyan

Write-Host "Network architecture complete!" -ForegroundColor Green