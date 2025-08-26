# Create Network Security Groups with defense-in-depth rules

param(
    [string]$ResourceGroupName = "rg-az500-network",
    [string]$Location = "East US"
)

Write-Host "Creating Network Security Groups with enterprise rules..." -ForegroundColor Green

# Web Subnet NSG - Internet-facing tier
$webNsgRules = @()
$webNsgRules += New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP-Internet" -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 -Access Allow
$webNsgRules += New-AzNetworkSecurityRuleConfig -Name "Allow-HTTPS-Internet" -Protocol Tcp -Direction Inbound -Priority 1010 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 443 -Access Allow
$webNsgRules += New-AzNetworkSecurityRuleConfig -Name "Allow-SSH-Corporate" -Protocol Tcp -Direction Inbound -Priority 1020 -SourceAddressPrefix "203.0.113.0/24" -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 -Access Allow
$webNsgRules += New-AzNetworkSecurityRuleConfig -Name "Deny-All-Inbound" -Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange * -Access Deny

$webNsg = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location -Name "nsg-web-subnet" -SecurityRules $webNsgRules

# App Subnet NSG - Internal tier  
$appNsgRules = @()
$appNsgRules += New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP-FromWeb" -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix "10.0.1.0/24" -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 8080 -Access Allow
$appNsgRules += New-AzNetworkSecurityRuleConfig -Name "Allow-SSH-Corporate" -Protocol Tcp -Direction Inbound -Priority 1020 -SourceAddressPrefix "203.0.113.0/24" -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 -Access Allow
$appNsgRules += New-AzNetworkSecurityRuleConfig -Name "Deny-All-Inbound" -Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange * -Access Deny

$appNsg = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location -Name "nsg-app-subnet" -SecurityRules $appNsgRules

# Database Subnet NSG - Most restrictive tier
$dbNsgRules = @()
$dbNsgRules += New-AzNetworkSecurityRuleConfig -Name "Allow-SQL-FromApp" -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix "10.0.2.0/24" -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 1433 -Access Allow
$dbNsgRules += New-AzNetworkSecurityRuleConfig -Name "Allow-SSH-Corporate" -Protocol Tcp -Direction Inbound -Priority 1020 -SourceAddressPrefix "203.0.113.0/24" -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 -Access Allow
$dbNsgRules += New-AzNetworkSecurityRuleConfig -Name "Deny-All-Inbound" -Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange * -Access Deny

$dbNsg = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location -Name "nsg-database-subnet" -SecurityRules $dbNsgRules

Write-Host "Network Security Groups created:" -ForegroundColor Yellow
Write-Host "- Web Tier: HTTP/HTTPS from Internet, SSH from Corporate" -ForegroundColor Cyan
Write-Host "- App Tier: Port 8080 from Web only, SSH from Corporate" -ForegroundColor Cyan
Write-Host "- Database Tier: Port 1433 from App only, SSH from Corporate" -ForegroundColor Cyan

Write-Host "NSG security rules complete!" -ForegroundColor Green