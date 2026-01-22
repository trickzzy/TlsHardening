@{
    RootModule        = 'TlsHardening.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '605e47dd-0469-4f76-b1fa-ecb550b01159'
    Author            = 'Ricky'
    CompanyName       = ''
    Description       = 'Enables TLS 1.2 for Schannel, sets .NET strong crypto defaults, and optionally enables cipher suites.'

    PowerShellVersion = '7.5.4'

    FunctionsToExport = @('Set-TlsHardening')
    CmdletsToExport   = @()
    VariablesToExport = '*'
    AliasesToExport   = @()

    PrivateData = @{
        PSData = @{
            Tags = @('Security','TLS','Schannel','.NET','Hardening','Windows','PowerShell')
            ReleaseNotes = 'Initial release'
        }
    }
}