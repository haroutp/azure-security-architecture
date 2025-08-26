# Assign users to appropriate groups based on enterprise roles

Write-Host "Assigning group memberships..." -ForegroundColor Green

# Get groups and users
$hrGroup = Get-AzureADGroup -Filter "DisplayName eq 'HR-Department'"
$itSecurityGroup = Get-AzureADGroup -Filter "DisplayName eq 'IT-Security-Team'"
$financeGroup = Get-AzureADGroup -Filter "DisplayName eq 'Finance-Department'"
$remoteWorkersGroup = Get-AzureADGroup -Filter "DisplayName eq 'Remote-Workers'"
$privilegedGroup = Get-AzureADGroup -Filter "DisplayName eq 'Privileged-Users'"

$testUser01 = Get-AzureADUser -Filter "UserPrincipalName eq 'testuser01@yourdomain.com'"
$testManager01 = Get-AzureADUser -Filter "UserPrincipalName eq 'testmanager01@yourdomain.com'"
$testAdmin01 = Get-AzureADUser -Filter "UserPrincipalName eq 'testadmin01@yourdomain.com'"
$testAnalyst01 = Get-AzureADUser -Filter "UserPrincipalName eq 'testanalyst01@yourdomain.com'"

# Strategic group assignments
Add-AzureADGroupMember -ObjectId $financeGroup.ObjectId -RefObjectId $testUser01.ObjectId
Add-AzureADGroupMember -ObjectId $remoteWorkersGroup.ObjectId -RefObjectId $testUser01.ObjectId

Add-AzureADGroupMember -ObjectId $hrGroup.ObjectId -RefObjectId $testManager01.ObjectId
Add-AzureADGroupMember -ObjectId $privilegedGroup.ObjectId -RefObjectId $testManager01.ObjectId
Add-AzureADGroupMember -ObjectId $remoteWorkersGroup.ObjectId -RefObjectId $testManager01.ObjectId

Add-AzureADGroupMember -ObjectId $itSecurityGroup.ObjectId -RefObjectId $testAdmin01.ObjectId
Add-AzureADGroupMember -ObjectId $privilegedGroup.ObjectId -RefObjectId $testAdmin01.ObjectId
Add-AzureADGroupMember -ObjectId $remoteWorkersGroup.ObjectId -RefObjectId $testAdmin01.ObjectId

Add-AzureADGroupMember -ObjectId $itSecurityGroup.ObjectId -RefObjectId $testAnalyst01.ObjectId
Add-AzureADGroupMember -ObjectId $remoteWorkersGroup.ObjectId -RefObjectId $testAnalyst01.ObjectId

Write-Host "Group memberships assigned successfully!" -ForegroundColor Green