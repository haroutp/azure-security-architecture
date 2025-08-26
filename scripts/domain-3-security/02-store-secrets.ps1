# Store enterprise secrets in Key Vault

param(
    [string]$ResourceGroupName = "rg-az500-network"
)

# Get Key Vault name from previous script
if (Test-Path "scripts/domain-3-security/.keyvault-name.txt") {
    $KeyVaultName = Get-Content "scripts/domain-3-security/.keyvault-name.txt"
} else {
    $KeyVaultName = Read-Host "Enter Key Vault name"
}

Write-Host "Storing enterprise secrets..." -ForegroundColor Green

# Common enterprise secrets
$secrets = @{
    "VM-Admin-Password" = "AzureTest123!"
    "Database-Connection-String" = "Server=vm-db-01;Database=ProductionDB;Integrated Security=true;"
    "API-Key-External-Service" = "sk_live_$(Get-Random -Minimum 100000 -Maximum 999999)"
    "Storage-Account-Key" = "$(Get-Random -Minimum 100000000 -Maximum 999999999)"
}

foreach ($secretName in $secrets.Keys) {
    $secureString = ConvertTo-SecureString $secrets[$secretName] -AsPlainText -Force
    
    Set-AzKeyVaultSecret `
        -VaultName $KeyVaultName `
        -Name $secretName `
        -SecretValue $secureString
    
    Write-Host "Stored secret: $secretName" -ForegroundColor Yellow
}

Write-Host "Enterprise secrets stored successfully!" -ForegroundColor Green