# KQL Queries for Security Operations and Threat Hunting
# These queries demonstrate security investigation patterns

Write-Host "KQL Threat Hunting Query Examples" -ForegroundColor Green

# Store KQL queries as here-strings for easy reference
$kqlQueries = @{}

# Failed Login Detection
$kqlQueries["FailedLogins"] = @"
// Detect excessive failed login attempts (Brute Force Detection)
SecurityEvent
| where EventID == 4625  // Failed logon events
| where TimeGenerated > ago(24h)
| summarize FailedAttempts = count() by Account, Computer, IpAddress
| where FailedAttempts > 10
| order by FailedAttempts desc
"@

# Privileged Account Activity
$kqlQueries["PrivilegedActivity"] = @"
// Monitor privileged account sign-ins
SigninLogs
| where UserPrincipalName has "admin" or UserPrincipalName has "service"
| where TimeGenerated > ago(7d)
| project TimeGenerated, UserPrincipalName, Location, IPAddress, ResultType
| order by TimeGenerated desc
"@

# Unusual Location Access
$kqlQueries["UnusualLocations"] = @"
// Detect sign-ins from unusual locations
SigninLogs
| where TimeGenerated > ago(30d)
| summarize LocationCount = dcount(Location) by UserPrincipalName
| where LocationCount > 3
| join (
    SigninLogs
    | where TimeGenerated > ago(7d)
    | project UserPrincipalName, Location, TimeGenerated
) on UserPrincipalName
| project UserPrincipalName, Location, TimeGenerated, LocationCount
| order by LocationCount desc
"@

# Resource Creation Anomalies
$kqlQueries["ResourceAnomalies"] = @"
// Detect unusual resource creation activity
AzureActivity
| where OperationName has "Create" or OperationName has "Deploy"
| where TimeGenerated > ago(24h)
| summarize ResourceCreations = count() by Caller, ResourceGroup
| where ResourceCreations > 5
| order by ResourceCreations desc
"@

# Network Security Group Changes
$kqlQueries["NSGChanges"] = @"
// Monitor Network Security Group rule changes
AzureActivity
| where ResourceProvider == "Microsoft.Network"
| where OperationName contains "securityRules"
| where TimeGenerated > ago(7d)
| project TimeGenerated, Caller, OperationName, ResourceGroup, Resource
| order by TimeGenerated desc
"@

# Key Vault Access Patterns
$kqlQueries["KeyVaultAccess"] = @"
// Analyze Key Vault access patterns
KeyVaultLogs
| where TimeGenerated > ago(24h)
| where ResultType == "Success"
| summarize AccessCount = count() by CallerIPAddress, Resource
| where AccessCount > 100
| order by AccessCount desc
"@

# Output queries to files for reference
Write-Host "Saving KQL queries to files..." -ForegroundColor Yellow

foreach ($queryName in $kqlQueries.Keys) {
    $fileName = "scripts/domain-4-operations/kql-$($queryName.ToLower()).kql"
    $kqlQueries[$queryName] | Out-File -FilePath $fileName -Encoding UTF8
    Write-Host "Saved: $fileName" -ForegroundColor Cyan
}

Write-Host "KQL threat hunting queries ready!" -ForegroundColor Green
Write-Host "Use these queries in Sentinel Logs or Hunting sections" -ForegroundColor Yellow