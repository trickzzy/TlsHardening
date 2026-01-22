BeforeAll {
    $modulePath = Join-Path $PSScriptRoot "..\TlsHardening.psd1"
    Import-Module $modulePath -Force
}

Describe "Set-TlsHardening" {

    BeforeEach {
        Mock -CommandName Assert-Admin
        Mock -CommandName New-Item
        Mock -CommandName New-ItemProperty
        Mock -CommandName Get-Command -MockWith { return $null }
        Mock -CommandName Write-Warning
        Mock -CommandName Enable-TlsCipherSuite
    }

    It "runs without error in -WhatIf mode" {
        { Set-TlsHardening -WhatIf } | Should -Not -Throw
    }

    It "writes registry keys/values (mocked)" {
        Set-TlsHardening -WhatIf
        Should -Invoke New-Item -TimesGreaterOrEqual 2
        Should -Invoke New-ItemProperty -TimesGreaterOrEqual 4
    }

    It "warns if Enable-TlsCipherSuite is not available" {
        Set-TlsHardening -WhatIf
        Should -Invoke Write-Warning -Times 1
    }
}