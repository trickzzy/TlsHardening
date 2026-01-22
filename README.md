# TlsHardening

PowerShell module to apply Windows TLS hardening:
- Enables TLS 1.2 for Schannel (Client/Server)
- Configures .NET 4.x to use System default TLS versions and Strong Crypto
- Optionally enables selected TLS cipher suites (if supported)

## Usage

Open PowerShell as Administrator:

```powershell
Import-Module .\TlsHardening.psd1 -Force
Set-TlsHardening -WhatIf
Set-TlsHardening -Confirm