# Tests\Set-TlsHardening.Tests.ps1
# Requires Pester 5+

BeforeAll {
    $modulePath = Join-Path $PSScriptRoot "..\TlsHardening.psd1"
    Import-Module $modulePath -Force
}

Describe "Set-TlsHardening" {

    BeforeEach {
        # Mock in MODULE scope so calls made from inside the module are intercepted
        InModuleScope TlsHardening {
            Mock Assert-Admin { }                # avoid admin requirement in CI
            Mock Ensure-RegistryKey { }          # avoid touching registry
            Mock Set-DwordValue { }              # avoid touching registry
            Mock Get-Command { return $null }    # default: cipher cmd missing
            Mock Write-Warning { }
            Mock Enable-TlsCipherSuite { }
        }
    }

    It "runs without error in -WhatIf mode" {
        InModuleScope TlsHardening {
            { Set-TlsHardening -WhatIf } | Should -Not -Throw
        }
    }

    It "applies expected registry operations via helper calls" {
        InModuleScope TlsHardening {
            Set-TlsHardening -WhatIf

            # TLS 1.2 Server + Client keys
            Should -Invoke Ensure-RegistryKey -Times 2

            # 4x Schannel + 4x .NET DWORDs = 8
            Should -Invoke Set-DwordValue -Times 8
        }
    }

    It "warns when Enable-TlsCipherSuite is not available" {
        InModuleScope TlsHardening {
            Set-TlsHardening -WhatIf
            Should -Invoke Write-Warning -Times 1
        }
    }

    It "attempts to enable cipher suites when cmdlet is available" {
        InModuleScope TlsHardening {
            Mock Get-Command { return @{ Name = 'Enable-TlsCipherSuite' } }

            Set-TlsHardening -WhatIf

            # Called once per suite in default list (3), but -WhatIf still calls the cmdlet
            # since our function gates with ShouldProcess; in -WhatIf, ShouldProcess returns $true
            # but PowerShell handles the WhatIf messaging. We still expect attempted calls.
            Should -Invoke Enable-TlsCipherSuite -TimesGreaterOrEqual 1
        }
    }
}
