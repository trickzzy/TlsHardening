[![CI](https://github.com/trickzzy/TlsHardening/actions/workflows/ci.yml/badge.svg)](https://github.com/trickzzy/TlsHardening/actions/workflows/ci.yml)

# TlsHardening

PowerShell module to apply Windows TLS hardening in a repeatable, auditable way:

- Enables **TLS 1.2** for Schannel (**Client/Server**)
- Configures **.NET 4.x** to use **System default TLS versions** and **Strong Crypto**
- Optionally enables selected **TLS cipher suites** (if supported on the OS)

## Why this exists
Standardizes TLS 1.2 and .NET crypto defaults across Windows systems using an idempotent script with `-WhatIf` / `-Confirm` support.

## Usage

### Import the module (from the repo folder)
```powershell
Import-Module .\TlsHardening.psd1 -Force
Get-Command Set-TlsHardening