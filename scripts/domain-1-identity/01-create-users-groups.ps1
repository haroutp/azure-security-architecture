# AZ-500 Lab: Domain 1 - Identity & Access Management
# Creates enterprise test users and security groups

# Connect to Azure AD
Connect-AzureAD

# Create password profile for test users
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "TempPass123!"
$PasswordProfile.ForceChangePasswordNextLogin = $true

Write-Host "Creating test users..." -ForegroundColor Green

# Create test users
$users = @(
    @{Name="Test User 01"; UPN="testuser01@yourdomain.com"; Purpose="Standard employee"},
    @{Name="Test Manager 01"; UPN="testmanager01@yourdomain.com"; Purpose="Department manager"},
    @{Name="Test Admin 01"; UPN="testadmin01@yourdomain.com"; Purpose="IT administrator"},
    @{Name="Test Analyst 01"; UPN="testanalyst01@yourdomain.com"; Purpose="SOC analyst"},
    @{Name="Emergency Admin"; UPN="emergencyadmin@yourdomain.com"; Purpose="Break glass account"}
)

foreach ($user in $users) {
    New-AzureADUser -DisplayName $user.Name -UserPrincipalName $user.UPN -PasswordProfile $PasswordProfile -AccountEnabled $true
    Write-Host "Created: $($user.Name) - $($user.Purpose)" -ForegroundColor Yellow
}

Write-Host "Creating security groups..." -ForegroundColor Green

# Create security groups
$groups = @(
    @{Name="HR-Department"; Description="Human resources team"},
    @{Name="IT-Security-Team"; Description="Security operations team"},
    @{Name="Finance-Department"; Description="Finance team"},
    @{Name="Remote-Workers"; Description="Remote employees"},
    @{Name="Privileged-Users"; Description="High-privilege users"}
)

foreach ($group in $groups) {
    New-AzureADGroup -DisplayName $group.Name -SecurityEnabled $true -MailEnabled $false -MailNickName ($group.Name.Replace("-","").ToLower()) -Description $group.Description
    Write-Host "Created group: $($group.Name)" -ForegroundColor Yellow
}

Write-Host "Identity foundation complete!" -ForegroundColor Green