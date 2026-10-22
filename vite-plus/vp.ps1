# Vite+ PowerShell wrapper (https://viteplus.dev)
$__vp_bin = '/home/neal/.local/share/vite-plus/bin'
$__vp_command_index = 0
if ($args.Count -ge 1) {
    if ($args[0] -eq "-C") {
        $__vp_command_index = 2
    } elseif ("$($args[0])" -like "-C?*") {
        $__vp_command_index = 1
    }
}
# Intercept `vp env use` to set/unset VP_NODE_VERSION in the current session.
if ($args.Count -ge ($__vp_command_index + 2) -and $args[$__vp_command_index] -eq "env" -and $args[$__vp_command_index + 1] -eq "use") {
    if ($args -contains "-h" -or $args -contains "--help") {
        & (Join-Path $__vp_bin "vp") @args
        exit $LASTEXITCODE
    }
    $previousEvalEnable = $env:VP_ENV_USE_EVAL_ENABLE
    $previousShell = $env:VP_SHELL
    $previousErrorActionPreference = $ErrorActionPreference
    try {
        $env:VP_ENV_USE_EVAL_ENABLE = "1"
        $env:VP_SHELL = "pwsh"
        # Windows PowerShell 5.1 treats native stderr as an error when redirected.
        $ErrorActionPreference = "Continue"
        $output = & (Join-Path $__vp_bin "vp") @args 2>&1 | ForEach-Object {
            if ($_ -is [System.Management.Automation.ErrorRecord]) {
                Write-Host $_.Exception.Message
            } else {
                $_
            }
        }
    } finally {
        $ErrorActionPreference = $previousErrorActionPreference
        $env:VP_ENV_USE_EVAL_ENABLE = $previousEvalEnable
        $env:VP_SHELL = $previousShell
    }
    if ($LASTEXITCODE -eq 0 -and $output) {
        Invoke-Expression ($output -join "`n")
    }
} else {
    & (Join-Path $__vp_bin "vp") @args
}
# Exits only this script, preserving the caller's session and native exit code.
exit $LASTEXITCODE
