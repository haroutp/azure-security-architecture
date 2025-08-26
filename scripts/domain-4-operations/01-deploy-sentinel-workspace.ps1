# AZ-500 Lab: Domain 4 - Microsoft Sentinel SIEM Deployment
# Creates Log Analytics workspace and enables Sentinel

param(
    [string]$ResourceGroupName = "rg-az500-network",
    [string]$Location = "East US",
    [string]$WorkspaceName = "az500-sentinel-workspace"
)

Write-Host "Deploying Microsoft Sentinel SIEM..." -ForegroundColor Green

# Create Log Analytics workspace for Sentinel
$workspace = New-AzOperationalInsightsWorkspace `
    -ResourceGroupName $ResourceGroupName `
    -Name $WorkspaceName `
    -Location $Location `
    -Sku "PerGB2018"

Write-Host "Log Analytics workspace created:" -ForegroundColor Yellow
Write-Host "- Name: $WorkspaceName" -ForegroundColor Cyan
Write-Host "- SKU: PerGB2018 (Pay-per-GB)" -ForegroundColor Cyan
Write-Host "- Resource ID: $($workspace.ResourceId)" -ForegroundColor Cyan

# Store workspace details for other scripts
@{
    WorkspaceName = $WorkspaceName
    WorkspaceId = $workspace.CustomerId
    ResourceId = $workspace.ResourceId
} | ConvertTo-Json | Out-File -FilePath "scripts/domain-4-operations/.workspace-config.json"

Write-Host "Sentinel workspace foundation ready!" -ForegroundColor Green
Write-Host "Next: Enable Sentinel through Azure Portal (security.microsoft.com)" -ForegroundColor Yellow