# Domain 1: Identity & Access Management Scripts

## Overview
Scripts for enterprise identity architecture with Azure Active Directory, including users, groups, conditional access, and privileged identity management.

## Scripts

### 01-create-users-groups.ps1
Creates enterprise test users and security groups for realistic Azure security scenarios.

**Created Users:**
- `testuser01` - Standard employee for basic conditional access testing
- `testmanager01` - Department manager for PIM and user management scenarios
- `testadmin01` - IT administrator for privileged access testing
- `testanalyst01` - SOC analyst for security operations scenarios  
- `emergencyadmin` - Break glass account (excluded from all policies)

**Created Groups:**
- `HR-Department` - Human resources team
- `IT-Security-Team` - Security operations team
- `Finance-Department` - Finance team (sensitive data access)
- `Remote-Workers` - Location-based conditional access testing
- `Privileged-Users` - Enhanced security policies

**Usage:**
```powershell
.\01-create-users-groups.ps1
```

### 02-assign-group-memberships.ps1
Assigns users to appropriate security groups based on enterprise role structure.

**Group Assignment Logic:**
- TestUser01 → Finance + Remote Workers
- TestManager01 → HR + Privileged Users + Remote Workers
- TestAdmin01 → IT Security + Privileged Users + Remote Workers  
- TestAnalyst01 → IT Security + Remote Workers
- EmergencyAdmin → No groups (isolated)

**Usage:**
```powershell
.\02-assign-group-memberships.ps1
```

## Prerequisites
- Azure AD PowerShell module: `Install-Module AzureAD`
- Global Administrator or User Administrator role
- Azure AD P1/P2 license for advanced features

## Conditional Access Integration
These users and groups integrate with:
- Geographic access policies (Named Locations)
- Device compliance requirements
- Risk-based conditional access
- Application-specific security controls

## PIM Integration  
Privileged users (TestManager01, TestAdmin01) are configured for:
- Just-in-time role activation
- Approval workflows for sensitive roles
- Time-limited administrative access
- Comprehensive audit logging

## Security Considerations
- All users created with temporary passwords requiring change
- Break glass account isolated from automated policies
- Group structure follows principle of least privilege
- Role assignments support security testing scenarios