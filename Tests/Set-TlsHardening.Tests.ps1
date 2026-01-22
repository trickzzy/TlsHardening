BeforeAll {
    $modulePath = Join-Path $PSScriptRoot "..\TlsHardening.psd1"
    Import-Module $modulePath -Force
}

Describe "Set-TlsHardening" {

    BeforeEach {
        # Mock INSIDE the module so CI doesn't need admin and won't touch registry
        Mock -ModuleName TlsHardening Assert-Admin { }
        Mock -ModuleName TlsHardening New-RegistryKey { }
        Mock -ModuleName TlsHardening Set-DwordValue { }

        # Default: pretend Enable-TlsCipherSuite cmdlet isn't available
        Mock -ModuleName TlsHardening Get-Command { return $null }

        Mock -ModuleName TlsHardening Write-Warning { }
        Mock -ModuleName TlsHardening Enable-TlsCipherSuite { }
    }

    It "runs without error in -WhatIf mode" {
        { Set-TlsHardening -WhatIf } | Should -Not -Throw
    }

    It "invokes helper calls for TLS 1.2 + .NET settings" {
        Set-TlsHardening -WhatIf

        Should -Invoke -ModuleName TlsHardening New-RegistryKey -Times 2
        Should -Invoke -ModuleName TlsHardening Set-DwordValue  -Times 8
    }

    It "warns when Enable-TlsCipherSuite is not available" {
        Set-TlsHardening -WhatIf
        Should -Invoke -ModuleName TlsHardening Write-Warning -Times 1
    }

    It "attempts to enable cipher suites when cmdlet is available" {
        Mock -ModuleName TlsHardening Get-Command { return @{ Name = 'Enable-TlsCipherSuite' } }

        Set-TlsHardening -WhatIf
        Should -Invoke -ModuleName TlsHardening Enable-TlsCipherSuite -TimesGreaterOrEqual 1
    }
}
