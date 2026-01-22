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

    It "emits a warning when Enable-TlsCipherSuite is not available" {
        $warnings = & {
            $WarningPreference = 'Continue'
            Set-TlsHardening -WhatIf
        } 3>&1

        # At least one warning record should be present
        $warnings | Should -Not -BeNullOrEmpty
    }
}