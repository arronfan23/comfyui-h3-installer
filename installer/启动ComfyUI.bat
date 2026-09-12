@echo off
rem ============================================================
rem  sanmaocloud (san mao yun) - ComfyUI H3 launcher
rem  Fully self-contained single file: the PowerShell body is
rem  embedded below. You may copy THIS FILE ALONE anywhere.
rem  NOTE: do NOT add "chcp 65001" here. With chcp 65001, cmd.exe
rem  mis-tracks its byte position in this UTF-8 file (the embedded
rem  Chinese body below) and ends up executing body fragments as
rem  commands. The PowerShell body inherits the console codepage
rem  (GBK on Chinese Windows), which displays Chinese correctly.
rem ============================================================
title sanmaocloud - ComfyUI H3
set "SANMAO_BATDIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$m='#===SANMAOCLOUD-PS1'+'-BEGIN==='; $src=[IO.File]::ReadAllText('%~f0',[Text.Encoding]::UTF8); $parts=$src -split [regex]::Escape($m),2; [IO.File]::WriteAllText((Join-Path $env:TEMP 'sanmaocloud-comfyui-launcher.ps1'), $parts[1], (New-Object System.Text.UTF8Encoding($true)))"
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\sanmaocloud-comfyui-launcher.ps1" %*
echo.
pause
exit /b
#===SANMAOCLOUD-PS1-BEGIN===
$ErrorActionPreference = 'Continue'
# 继承控制台默认代码页（中文 Windows 为 GBK），保证中文正常显示；
# 不要改成 UTF8，也不要在 bat 头部加 chcp 65001（会触发 cmd 字节错位 bug）
$ProgressPreference = 'SilentlyContinue'

# ---- 品牌横幅（SMO 像素字 Logo，绿蓝真彩渐变 + 错位描边） ----
$smoRows = @(
    ' ██████   ███     ███   ██████ ',
    '██    ██  ████   ████  ██    ██',
    '██        ██ ██ ██ ██  ██    ██',
    ' ██████   ██  ███  ██  ██    ██',
    '      ██  ██   █   ██  ██    ██',
    '██    ██  ██       ██  ██    ██',
    ' ██████   ██       ██   ██████ '
)

# 尝试启用控制台 ANSI 真彩色（Win10+），失败则回退 16 色方案
$script:SmoAnsi = $false
try {
    Add-Type -Namespace SmoConsole -Name Native -ErrorAction Stop -MemberDefinition @"
[System.Runtime.InteropServices.DllImport("kernel32.dll")] public static extern System.IntPtr GetStdHandle(int h);
[System.Runtime.InteropServices.DllImport("kernel32.dll")] public static extern bool GetConsoleMode(System.IntPtr h, out int m);
[System.Runtime.InteropServices.DllImport("kernel32.dll")] public static extern bool SetConsoleMode(System.IntPtr h, int m);
"@
    $stdOut = [SmoConsole.Native]::GetStdHandle(-11)
    $consoleMode = 0
    if ([SmoConsole.Native]::GetConsoleMode($stdOut, [ref]$consoleMode)) {
        $script:SmoAnsi = [SmoConsole.Native]::SetConsoleMode($stdOut, $consoleMode -bor 0x4)
    }
} catch {}

# 合并本行方块与上一行的错位描边，输出 (字符, 类型) 网格；类型 B=方块 E=描边
function Get-SmoGridRow([int]$r) {
    $block = if ($r -lt $smoRows.Count) { $smoRows[$r] } else { '' }
    $echo  = if ($r -ge 1) { $smoRows[$r - 1] } else { '' }
    $cells = @()
    for ($c = 0; $c -le $smoRows[0].Length; $c++) {
        if ($c -lt $block.Length -and $block[$c] -eq [char]0x2588) { $cells += 'B' }
        elseif ($c -ge 1 -and ($c - 1) -lt $echo.Length -and $echo[$c - 1] -eq [char]0x2588) { $cells += 'E' }
        else { $cells += ' ' }
    }
    return $cells
}

$esc = [char]27
$gradTop = @(16, 217, 126)    # 顶部鲜绿
$gradBot = @(51, 102, 255)    # 底部亮蓝
$fallback16 = 'Green', 'Green', 'DarkCyan', 'Cyan', 'Cyan', 'Blue', 'Blue'
Write-Host ''
for ($r = 0; $r -le $smoRows.Count; $r++) {
    $cells = Get-SmoGridRow $r
    if ($script:SmoAnsi) {
        $t = [Math]::Min($r, 6) / 6.0
        $gR = [int]($gradTop[0] + ($gradBot[0] - $gradTop[0]) * $t)
        $gG = [int]($gradTop[1] + ($gradBot[1] - $gradTop[1]) * $t)
        $gB = [int]($gradTop[2] + ($gradBot[2] - $gradTop[2]) * $t)
        $eR = [int]($gR * 0.38); $eG = [int]($gG * 0.38); $eB = [int]($gB * 0.38)
        $line = '   '
        $prev = ' '
        foreach ($cell in $cells) {
            if ($cell -ne $prev) {
                if ($cell -eq 'B') { $line += "$esc[38;2;${gR};${gG};${gB}m" }
                elseif ($cell -eq 'E') { $line += "$esc[38;2;${eR};${eG};${eB}m" }
                $prev = $cell
            }
            if ($cell -eq 'B') { $line += [char]0x2588 }
            elseif ($cell -eq 'E') { $line += [char]0x2588 }
            else { $line += ' ' }
        }
        Write-Host ($line + "$esc[0m")
    } else {
        $curText = '   '
        $curColor = $null
        foreach ($cell in $cells) {
            if ($cell -eq 'B') { $ch = [char]0x2588; $co = $fallback16[[Math]::Min($r, 6)] }
            elseif ($cell -eq 'E') { $ch = [char]0x2588; $co = 'DarkBlue' }
            else { $ch = ' '; $co = $null }
            if ($co -ne $curColor) {
                if ($curColor) { Write-Host $curText -NoNewline -ForegroundColor $curColor }
                else { Write-Host $curText -NoNewline }
                $curText = ''; $curColor = $co
            }
            $curText += $ch
        }
        if ($curColor) { Write-Host $curText -ForegroundColor $curColor }
        else { Write-Host $curText }
    }
}
Write-Host ''
Write-Host '  +----------------------------------------------------------+' -ForegroundColor DarkCyan
Write-Host '  |   sanmaocloud 三猫云' -ForegroundColor Cyan
Write-Host '  |   ComfyUI H3 一键启动' -ForegroundColor Cyan
Write-Host '  +----------------------------------------------------------+' -ForegroundColor DarkCyan
Write-Host ''

# ---- 启动 ComfyUI ----
$appDir = if ($env:SANMAO_BATDIR) { $env:SANMAO_BATDIR.TrimEnd('\') } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
Set-Location -LiteralPath $appDir
$venvPy = Join-Path $appDir 'venv\Scripts\python.exe'
if (-not (Test-Path $venvPy)) {
    Write-Host '  未找到 venv，请先运行一键安装.bat' -ForegroundColor Red
    exit 1
}
Write-Host '  浏览器访问: http://127.0.0.1:8188' -ForegroundColor Green
Write-Host '  本窗口是服务进程，使用中请勿关闭' -ForegroundColor Yellow
Write-Host ''
& $venvPy main.py
