# Enable VM disk encryption using Key Vault

param(
    [string]$ResourceGroupName = "rg-az500-network",
    [string]$VMName = "vm-db-01"
)

# Get Key Vault details
if (Test-Path "scripts/domain-3-security/.keyvault-name.txt") {
    $KeyVaultName = Get-Content "scripts/domain-3-security/.keyvault-name.txt"
} else {
    Write-Error "Key Vault name not found. Run 01-create-key-vault.ps1 first"
    exit
}

$vault = Get-AzKeyVault -VaultName $KeyVaultName

Write-Host "Enabling disk encryption for $VMName..." -ForegroundColor Green

# Check if VM is running
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Status
$vmStatus = ($vm.Statuses | Where-Object {$_.Code -like "PowerState*"}).DisplayStatus

if ($vmStatus -ne "VM running") {
    Write-Host "Starting VM $VMName..." -ForegroundColor Yellow
    Start-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
    
    # Wait for VM to be running
    do {
        Start-Sleep -Seconds 30
        $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Status
        $vmStatus = ($vm.Statuses | Where-Object {$_.Code -like "PowerState*"}).DisplayStatus
        Write-Host "VM Status: $vmStatus" -ForegroundColor Cyan
    } while ($vmStatus -ne "VM running")
}

# Enable disk encryption
Set-AzVMDiskEncryptionExtension `
    -ResourceGroupName $ResourceGroupName `
    -VMName $VMName `
    -DiskEncryptionKeyVaultUrl $vault.VaultUri `
    -DiskEncryptionKeyVaultId $vault.ResourceId `
    -VolumeType "All" `
    -Force

Write-Host "Disk encryption initiated for $VMName" -ForegroundColor Yellow
Write-Host "Encryption process may take 15-30 minutes to complete" -ForegroundColor Cyan

# Check encryption status
Write-Host "Current encryption status:" -ForegroundColor Green
Get-AzVmDiskEncryptionStatus -ResourceGroupName $ResourceGroupName -VMName $VMName