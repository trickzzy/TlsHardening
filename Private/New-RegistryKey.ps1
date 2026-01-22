function Ensure-RegistryKey {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param([Parameter(Mandatory)][string]$Path)

    if ($PSCmdlet.ShouldProcess($Path, "Ensure registry key exists")) {
        New-Item -Path $Path -Force | Out-Null
    }
}
