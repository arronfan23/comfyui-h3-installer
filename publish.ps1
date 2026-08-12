$ErrorActionPreference = "Stop"
$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoName = "comfyui-h3-installer"
$owner = "arronfan23"

Set-Location $repoDir

# ---- 取已保存的 GitHub 凭据（不回显令牌）----
$credOut = "protocol=https`nhost=github.com`n" | git credential fill
$token = ($credOut | Select-String '^password=(.+)$').Matches.Groups[1].Value
if (-not $token) { throw "未找到 github.com 的已保存凭据" }
$headers = @{ Authorization = "token $token"; Accept = "application/vnd.github+json"; "User-Agent" = "publish-script" }

# ---- 检查/创建远程仓库 ----
$exists = $false
try {
    Invoke-RestMethod "https://api.github.com/repos/$owner/$repoName" -Headers $headers | Out-Null
    $exists = $true
} catch {}
if ($exists) {
    Write-Host "远程仓库已存在，直接推送: $owner/$repoName"
} else {
    Write-Host "创建公开仓库: $owner/$repoName"
    $body = @{
        name = $repoName
        description = "一键安装 ComfyUI + MiniMax H3 全套模型，自动配置 Codex MCP / One-click ComfyUI + H3 installer with Codex MCP"
        private = $false
        has_issues = $true
        has_wiki = $false
        auto_init = $false
    } | ConvertTo-Json
    Invoke-RestMethod -Method Post -Uri "https://api.github.com/user/repos" -Headers $headers -Body $body -ContentType "application/json" | Out-Null
}

# ---- 本地 git 初始化并提交 ----
if (-not (Test-Path (Join-Path $repoDir ".git"))) {
    git init -b main
}
git add -A
$staged = git diff --cached --name-only
if ($staged) {
    git commit -m "feat: ComfyUI + H3 one-click installer with Codex MCP integration" | Out-Host
} else {
    Write-Host "没有新的变更需要提交"
}

# ---- 推送 ----
$remoteUrl = "https://github.com/$owner/$repoName.git"
$remotes = git remote
if ($remotes -contains "origin") { git remote set-url origin $remoteUrl } else { git remote add origin $remoteUrl }
git push -u origin main | Out-Host
Write-Host ""
Write-Host "发布完成: https://github.com/$owner/$repoName" -ForegroundColor Green
