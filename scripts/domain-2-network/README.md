# Domain 2: Network Security Scripts

## Overview
Scripts for multi-tier network architecture with defense-in-depth security controls using Virtual Networks and Network Security Groups.

## Network Architecture
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Internet   │───▶│  Web Tier   │───▶│  App Tier   │───▶│Database Tier│
│             │    │10.0.1.0/24  │    │10.0.2.0/24  │    │10.0.3.0/24  │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘

| Layer | Subnet | Access |
|-------|--------|---------|
| Internet → Web Tier | 10.0.1.0/24 | Public |
| Web → App Tier | 10.0.2.0/24 | Private |
| App → Database Tier | 10.0.3.0/24 | Private |

## Scripts

### 01-create-network-architecture.ps1
Creates three-tier VNet with segmented subnets for web, application, and database tiers.

**Network Design:**
- **VNet:** `vnet-az500-multitier` (10.0.0.0/16)
- **WebSubnet:** 10.0.1.0/24 (Internet-facing)
- **AppSubnet:** 10.0.2.0/24 (Internal only)
- **DatabaseSubnet:** 10.0.3.0/24 (Most restrictive)

**Usage:**
```powershell
.\01-create-network-architecture.ps1 -ResourceGroupName "rg-az500-network"
```

### 02-create-security-groups.ps1
Creates Network Security Groups with defense-in-depth rules for each tier.
**Security Rules by Tier:**
**Web Tier NSG:**

- Allow HTTP (80) from Internet
- Allow HTTPS (443) from Internet
- Allow SSH (22) from Corporate Network only
- Deny all other inbound traffic

**App Tier NSG:**

- Allow HTTP (8080) from Web Subnet only
- Allow SSH (22) from Corporate Network only
- Deny all other inbound traffic

**Database Tier NSG:**

- Allow SQL (1433) from App Subnet only
- Allow SSH (22) from Corporate Network only
- Deny all other inbound traffic

**Usage:**
```powershell
.\02-create-security-groups.ps1 -ResourceGroupName "rg-az500-network"
```

### 03-associate-nsgs.ps1
Associates Network Security Groups with their respective subnets.

**Associations:**
- `nsg-web-subnet` → WebSubnet
- `nsg-app-subnet` → AppSubnet
- `nsg-database-subnet` → DatabaseSubnet

**Usage:**
```powershell
.\03-associate-nsgs.ps1 -ResourceGroupName "rg-az500-network"
```

## Security Features

- **Network Segmentation:** Prevents lateral movement between tiers
- **Defense in Depth:** Multiple security layers protect sensitive data
- **Principle of Least Privilege:** Each tier only allows necessary traffic
- **Corporate Access Control:** Management access restricted to known IP ranges

## Traffic Flow Validation
Expected traffic patterns:

- ✅ Internet → Web Tier (HTTP/HTTPS)
- ✅ Web → App Tier (Port 8080)
- ✅ App → Database Tier (Port 1433)
- ✅ Corporate Network → All Tiers (SSH management)
- ❌ Internet → App/Database Tiers (BLOCKED)
- ❌ Cross-tier unauthorized traffic (BLOCKED)

## Compliance Alignment
- **PCI-DSS:** Network segmentation requirements
- **Zero Trust:** Explicit verification of all network traffic
- **Enterprise Standards:** Multi-tier architecture best practices

## Prerequisites
- Azure PowerShell module: `Install-Module Az`
- Network Contributor role or higher
- Understanding of CIDR notation and network security principles