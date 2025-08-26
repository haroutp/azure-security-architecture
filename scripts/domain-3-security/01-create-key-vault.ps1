# AZ-500 Lab: Domain 3 - Azure Key Vault with Enterprise Security
# Creates Key Vault with RBAC authorization and security features

param(
    [string]$ResourceGroupName = "rg-az500-network",
    [string]$Location = "East US",
    [string]$KeyVaultName = "kv-az500-secrets-$(Get-Random -Minimum 1000 -Maximum 9999)"
)

Write-Host "Creating enterprise Key Vault..." -ForegroundColor Green

# Create Key Vault with enterprise security features
$keyVault = New-AzKeyVault `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -VaultName $KeyVaultName `
    -EnabledForDiskEncryption `
    -EnableSoftDelete `
    -EnablePurgeProtection `
    -EnableRbacAuthorization

Write-Host "Key Vault '$KeyVaultName' created with features:" -ForegroundColor Yellow
Write-Host "- RBAC Authorization: Enabled" -ForegroundColor Cyan
Write-Host "- Disk Encryption: Enabled" -ForegroundColor Cyan
Write-Host "- Soft Delete: Enabled" -ForegroundColor Cyan
Write-Host "- Purge Protection: Enabled" -ForegroundColor Cyan

# Get current user for role assignment
Write-Host "Configuring RBAC permissions..." -ForegroundColor Green
$currentUser = Get-AzADUser -UserPrincipalName (Get-AzContext).Account.Id

if (-not $currentUser) {
    # Handle external users (B2B guests)
    $currentUser = Get-AzADUser -Filter "startswith(userPrincipalName,'$(((Get-AzContext).Account.Id).Split('@')[0])')"
}

# Assign Key Vault Administrator role
New-AzRoleAssignment `
    -ObjectId $currentUser.Id `
    -RoleDefinitionName "Key Vault Administrator" `
    -Scope $keyVault.ResourceId

Write-Host "RBAC permissions configured for user: $($currentUser.DisplayName)" -ForegroundColor Yellow

# Store Key Vault name for other scripts
$keyVault.VaultName | Out-File -FilePath "scripts/domain-3-security/.keyvault-name.txt"

Write-Host "Key Vault setup complete!" -ForegroundColor Green