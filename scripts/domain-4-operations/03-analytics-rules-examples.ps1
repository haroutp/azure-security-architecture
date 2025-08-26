# Analytics Rules Configuration Examples
# Demonstrates automated threat detection rule structures

Write-Host "Analytics Rules Examples for Sentinel" -ForegroundColor Green

# Define analytics rule templates
$analyticsRules = @{}

$analyticsRules["ExcessiveFailedLogins"] = @{
    Name = "Excessive Failed Login Attempts"
    Description = "Detects multiple failed login attempts from same source"
    Query = @"
SecurityEvent
| where EventID == 4625
| where TimeGenerated > ago(1h)
| summarize count() by Account, Computer
| where count_ > 5
"@
    Frequency = "PT5M"  # Every 5 minutes
    Period = "PT1H"     # Look back 1 hour
    Threshold = 1
    Severity = "Medium"
}

$analyticsRules["SuspiciousResourceDeployment"] = @{
    Name = "Suspicious Resource Deployment Activity"
    Description = "Detects unusual resource creation patterns"
    Query = @"
AzureActivity
| where OperationName has "Create"
| where TimeGenerated > ago(1h)
| summarize count() by Caller
| where count_ > 10
"@
    Frequency = "PT15M"  # Every 15 minutes
    Period = "PT1H"      # Look back 1 hour
    Threshold = 1
    Severity = "High"
}

$analyticsRules["PrivilegedAccountActivity"] = @{
    Name = "Off-Hours Privileged Account Activity"
    Description = "Detects privileged account usage outside business hours"
    Query = @"
SigninLogs
| where UserPrincipalName has "admin"
| where TimeGenerated > ago(1h)
| where hourofday(TimeGenerated) < 8 or hourofday(TimeGenerated) > 18
"@
    Frequency = "PT30M"  # Every 30 minutes
    Period = "PT1H"      # Look back 1 hour
    Threshold = 1
    Severity = "High"
}

# Export rules as JSON for reference
Write-Host "Exporting analytics rules templates..." -ForegroundColor Yellow

$analyticsRules | ConvertTo-Json -Depth 3 | Out-File -FilePath "scripts/domain-4-operations/analytics-rules-templates.json"

foreach ($ruleName in $analyticsRules.Keys) {
    $rule = $analyticsRules[$ruleName]
    Write-Host "Rule: $($rule.Name)" -ForegroundColor Cyan
    Write-Host "  Frequency: $($rule.Frequency)" -ForegroundColor White
    Write-Host "  Severity: $($rule.Severity)" -ForegroundColor White
}

Write-Host "Analytics rules templates ready!" -ForegroundColor Green
Write-Host "Import these templates in Sentinel Analytics section" -ForegroundColor Yellow