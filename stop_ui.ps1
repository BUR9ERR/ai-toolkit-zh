# stop_ui.ps1 - stop the ai-toolkit Web UI process tree
$ErrorActionPreference = 'SilentlyContinue'
Write-Host '=== Stopping ai-toolkit UI ==='
$targets = Get-CimInstance Win32_Process | Where-Object { $_.Name -match 'python|node' -and $_.CommandLine -match 'manager launch' }
if (-not $targets) {
    Write-Host 'No manager launch process found.'
} else {
    foreach ($t in $targets) {
        Write-Host ('Killing PID ' + $t.ProcessId + ' ...')
        taskkill /F /T /PID $t.ProcessId | Out-Null
    }
}
Start-Sleep -Seconds 2
$still = Get-NetTCPConnection -LocalPort 8675 -State Listen -ErrorAction SilentlyContinue
if ($still) { Write-Host 'WARNING: port 8675 still listening.' } else { Write-Host 'UI stopped. Port 8675 released.' }
