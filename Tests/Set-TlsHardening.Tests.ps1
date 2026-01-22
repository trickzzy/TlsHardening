$ErrorActionPreference = 'Stop'

BeforeAll {
    $modulePath = Join-Path $PSScriptRoot "..\TlsHardening.psd1"
    Import-Module $modulePath -Force -ErrorAction Stop
}

Describe "TlsHardening Module" {

    It "exports Set-TlsHardening" {
        (Get-Command Set-TlsHardening -ErrorAction Stop).Name | Should -Be 'Set-TlsHardening'
    }

    It "does not throw in -WhatIf mode (no admin required)" {
        { Set-TlsHardening -WhatIf } | Should -Not -Throw
    }

    It "handles cipher suite cmdlet availability appropriately" {
        $hasCmdlet = $null -ne (Get-Command Enable-TlsCipherSuite -ErrorAction SilentlyContinue)

        $warnings = & {
            $WarningPreference = 'Continue'
            Set-TlsHardening -WhatIf
        } 3>&1

        if ($hasCmdlet) {
            $warnings | Should -BeNullOrEmpty
        }
        else {
            $warnings | Should -Not -BeNullOrEmpty
        }
    }
}
