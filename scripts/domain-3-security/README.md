# Domain 3: Compute & Storage Security Scripts

## Overview
Scripts for data protection using Azure Key Vault, VM disk encryption, and secure storage accounts with enterprise-grade security controls.

## Security Architecture
Key Vault (RBAC) ←→ VM Disk Encryption ←→ Secure Storage
↓                      ↓                    ↓
Secrets Management    Data at Rest        SAS Tokens

## Scripts

### 01-create-key-vault.ps1
Creates enterprise Key Vault with RBAC authorization and security features.

**Security Features:**
- **RBAC Authorization:** Modern permission model
- **Soft Delete:** 90-day recovery window
- **Purge Protection:** Prevents permanent deletion
- **Disk Encryption:** Enabled for VM integration
- **Audit Logging:** Comprehensive access tracking

**Usage:**
```powershell
.\01-create-key-vault.ps1 -ResourceGroupName "rg-az500-network"
```
**Output:** Creates .keyvault-name.txt for other scripts

### 02-store-secrets.ps1
Stores common enterprise secrets in Key Vault with secure handling.
**Secrets Stored:**
- `VM-Admin-Password` - Virtual machine administrative credentials
- `Database-Connection-String` - Secure database connectivity
- `API-Key-External-Service` - Third-party service authentication
- `Storage-Account-Key` - Storage access credentials

**Usage:**
```powershell
.\02-store-secrets.ps1 -ResourceGroupName "rg-az500-network"
```

### 03-vm-disk-encryption.ps1
Enables Azure Disk Encryption on VMs using Key Vault customer-managed keys.

**Encryption Features:**
- **BitLocker Integration:** Windows disk encryption
- **Customer-Managed Keys:** Keys stored in Key Vault
- **Volume Encryption:** Both OS and data disks
- **Transparent Operation:** No application changes required

**Usage:**
```powershell
.\03-vm-disk-encryption.ps1 -ResourceGroupName "rg-az500-network" -VMName "vm-db-01"
```
**Prerequisites:** VM must be in running state

### 04-secure-storage-account.ps1
Creates enterprise storage account with network restrictions and security controls.

**Security Configuration:**

- **TLS 1.2 Minimum:** Modern encryption standards
- **HTTPS Only:** No insecure connections allowed
- **Network Restrictions:** Corporate IP access only
- **Default Deny:** Zero-trust network model
- **SAS Tokens:** Time-limited access credentials

**Usage:**
```powershell
.\04-secure-storage-account.ps1 -ResourceGroupName "rg-az500-network"
```
**Output:**

- Creates storage account with enterprise security
- Generates 2-hour SAS token for contractor access
- Saves storage account name to `.storage-account-name.txt`


## Security Integration Points

### Key Vault → VM Encryption
- Key Vault provides encryption keys
- VM disk encryption uses customer-managed keys
- Automatic key rotation supported
- Audit trail for all key operations

### Storage Security → SAS Tokens
- Time-limited access (2-hour expiry)
- Granular permissions (read/write specific)
- Network IP restrictions
- No permanent credential exposure

### Cross-Domain Integration
- **Domain 1:** Azure AD identities access Key Vault
- **Domain 2:** Network restrictions protect storage
- **Domain 4:** All access logged to Sentinel


## Enterprise Value

### Compliance Benefits
- **Data at Rest:** VM disks encrypted with customer keys
- **Data in Transit:** TLS 1.2 minimum encryption
- **Access Control:** Time-limited, audited access
- **Key Management:** Centralized, RBAC-protected

### Operational Benefits

- **Secret Rotation:** Centralized credential management
- **Audit Trail:** Complete access logging
- **Disaster Recovery:** Soft delete protection
- **Cost Optimization:** Pay-per-use model

## Prerequisites

- Azure PowerShell module: `Install-Module Az`
- Key Vault Administrator role (via RBAC)
- Virtual Machine Contributor role
- Storage Account Contributor role
- Understanding of encryption and access control principles

## Troubleshooting

- **RBAC Propagation:** Allow 30-60 seconds for permission changes
- **VM State:** Encryption requires VM to be running
- **Network Access:** Storage restrictions may block initial access
- **External Users:** B2B guests need special identity handling