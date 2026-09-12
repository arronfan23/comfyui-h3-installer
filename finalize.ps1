$here = Split-Path -Parent $MyInvocation.MyCommand.Path
foreach ($f in @('fix-eol.ps1', 'test-launcher.ps1', 'apply-launcher.ps1')) {
    $p = Join-Path $here $f
    if (Test-Path $p) { Remove-Item $p -Force }
}
Set-Location $here
git add -A
git commit -m "feat: branded terminal launcher (SMO banner + sanmaocloud title), revert desktop shortcut" | Out-Host
git push | Out-Host
git log --oneline -3
# 清理自身
Remove-Item (Join-Path $here 'finalize.ps1') -Force
