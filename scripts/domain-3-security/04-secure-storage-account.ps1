# Create enterprise-secure storage account with network restrictions

param(
    [string]$ResourceGroupName = "rg-az500-network",
    [string]$Location = "East US",
    [string]$StorageAccountName = "az500storageaccount$(Get-Random -Minimum 1000 -Maximum 9999)"
)

Write-Host "Creating enterprise-secure storage account..." -ForegroundColor Green

# Create storage account with security features
$storageAccount = New-AzStorageAccount `
    -ResourceGroupName $ResourceGroupName `
    -Name $StorageAccountName `
    -Location $Location `
    -SkuName "Standard_LRS" `
    -Kind "StorageV2" `
    -MinimumTlsVersion "TLS1_2" `
    -EnableHttpsTrafficOnly $true `
    -NetworkRuleSet @{
        bypass = "AzureServices"
        ipRules = @(@{ipAddressOrRange="203.0.113.0/24"; action="Allow"})
        virtualNetworkRules = @()
        defaultAction = "Deny"
    }

Write-Host "Storage account '$StorageAccountName' created with security features:" -ForegroundColor Yellow
Write-Host "- Minimum TLS Version: 1.2" -ForegroundColor Cyan
Write-Host "- HTTPS Only: Enabled" -ForegroundColor Cyan
Write-Host "- Network Access: Restricted (Corporate IP only)" -ForegroundColor Cyan
Write-Host "- Default Action: Deny" -ForegroundColor Cyan

# Generate time-limited SAS token for contractor access
Write-Host "Generating SAS token for temporary access..." -ForegroundColor Green

$ctx = $storageAccount.Context
$sasToken = New-AzStorageAccountSASToken `
    -Context $ctx `
    -ExpiryTime (Get-Date).AddHours(2) `
    -Permissions "rw" `
    -Service Blob `
    -ResourceType Container

Write-Host "SAS Token (2-hour expiry): $sasToken" -ForegroundColor Yellow
Write-Host "Storage security configuration complete!" -ForegroundColor Green

# Store storage account name for reference
$StorageAccountName | Out-File -FilePath "scripts/domain-3-security/.storage-account-name.txt"