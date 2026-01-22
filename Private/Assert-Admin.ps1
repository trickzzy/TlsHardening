function Assert-Admin {
    # If caller is running -WhatIf, don't require elevation because no changes are applied.
    if ($WhatIfPreference) { return }

    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (-not $isAdmin) {
        throw "This action requires Administrator privileges. Re-run PowerShell as Administrator."
    }
}