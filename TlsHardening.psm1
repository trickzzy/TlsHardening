# Load all public/private functions
$Public  = Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue
$Private = Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue

foreach ($file in @($Private + $Public)) {
    try { . $file.FullName }
    catch { throw "Failed to import: $($file.FullName). Error: $($_.Exception.Message)" }
}

Export-ModuleMember -Function ($Public.BaseName)