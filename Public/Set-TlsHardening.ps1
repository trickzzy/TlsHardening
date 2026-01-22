function Set-TlsHardening {
    <#
    .SYNOPSIS
    Applies Windows TLS hardening: enables TLS 1.2 for Schannel and configures .NET strong crypto defaults.

    .DESCRIPTION
    - Enables TLS 1.2 for Schannel Client/Server.
    - Sets .NET 4.x StrongCrypto and SystemDefaultTlsVersions for 64-bit and WOW6432Node.
    - Optionally enables specific TLS cipher suites (if supported by the OS).

    .PARAMETER EnableCipherSuites
    Cipher suites to enable (requires Enable-TlsCipherSuite cmdlet availability).

    .EXAMPLE
    Set-TlsHardening -WhatIf

    .EXAMPLE
    Set-TlsHardening -Confirm
    #>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [string[]]$EnableCipherSuites = @(
            'TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256',
            'TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256',
            'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
        )
    )

    Assert-Admin

    # --- Your original Schannel TLS 1.2 settings ---
    $SChannelRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"

    $tls12Server = Join-Path $SChannelRegPath "TLS 1.2\Server"
    $tls12Client = Join-Path $SChannelRegPath "TLS 1.2\Client"

    Ensure-RegistryKey -Path $tls12Server
    Ensure-RegistryKey -Path $tls12Client

    Set-DwordValue -Path $tls12Server -Name Enabled -Value 1
    Set-DwordValue -Path $tls12Server -Name DisabledByDefault -Value 0
    Set-DwordValue -Path $tls12Client -Name Enabled -Value 1
    Set-DwordValue -Path $tls12Client -Name DisabledByDefault -Value 0

    # --- Your original .NET strong crypto defaults ---
    $RegPath1 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319"
    $RegPath2 = "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"

    Set-DwordValue -Path $RegPath1 -Name SystemDefaultTlsVersions -Value 1
    Set-DwordValue -Path $RegPath1 -Name SchUseStrongCrypto -Value 1

    Set-DwordValue -Path $RegPath2 -Name SystemDefaultTlsVersions -Value 1
    Set-DwordValue -Path $RegPath2 -Name SchUseStrongCrypto -Value 1

    # --- Your original cipher suite enablement (if available) ---
    if ($EnableCipherSuites -and $EnableCipherSuites.Count -gt 0) {
        $cipherCmd = Get-Command Enable-TlsCipherSuite -ErrorAction SilentlyContinue
        if (-not $cipherCmd) {
            Write-Warning "Enable-TlsCipherSuite cmdlet not available on this system. Skipping cipher suite enablement."
        }
        else {
            foreach ($suite in $EnableCipherSuites) {
                if ($PSCmdlet.ShouldProcess($suite, "Enable TLS cipher suite")) {
                    try {
                        Enable-TlsCipherSuite -Name $suite -ErrorAction Stop
                    }
                    catch {
                        Write-Warning "Failed to enable cipher suite '$suite': $($_.Exception.Message)"
                    }
                }
            }
        }
    }

    Write-Host "TLS hardening registry changes applied. A reboot is recommended for Schannel changes to fully apply."
}