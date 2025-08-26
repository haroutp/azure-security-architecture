# Domain 4: Security Operations Scripts

## Overview
Scripts for Microsoft Sentinel SIEM deployment and security operations automation.

## Scripts

### 01-deploy-sentinel-workspace.ps1
Creates Log Analytics workspace foundation for Microsoft Sentinel SIEM.

**Usage:**
```powershell
.\01-deploy-sentinel-workspace.ps1 -ResourceGroupName "rg-az500-network"
```

### 02-kql-threat-hunting-queries.ps1
Collection of KQL queries for security investigation and threat hunting.
Generated Files:

`kql-failedlogins.kql` - Brute force detection
`kql-privilegedactivity.kql` - Admin account monitoring
`kql-unusuallocations.kql` - Geographic anomaly detection
`kql-resourceanomalies.kql` - Resource creation monitoring
`kql-nsgchanges.kql` - Network security monitoring
`kql-keyvaultaccess.kql` - Key Vault access analysis

### 03-analytics-rules-examples.ps1
Templates for automated threat detection rules.
**Features**:

Configurable frequency and thresholds
Multiple severity levels
Business logic for threat scenarios

## KQL Query Usage
Run these queries in:

Sentinel → Logs section
Sentinel → Hunting section
Log Analytics workspace directly

## Analytics Rules Implementation

Navigate to Sentinel → Analytics
Create new rule → Scheduled query rule
Use provided KQL queries and thresholds
Configure automated response actions

