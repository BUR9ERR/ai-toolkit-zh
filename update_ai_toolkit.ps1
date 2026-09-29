# AI-Toolkit 一键更新工具（检测 GitHub 版 vs 本地版 + 安全更新）
# 用法：
#   双击 update_ai_toolkit.bat  -> 交互模式（先检测，询问是否更新）
#   -CheckOnly                  -> 仅检测，不更新
#   -Auto                       -> 免交互直接更新
# 说明：
#   - 更新 = git pull --ff-only（绝不覆盖本地改动）+ 依赖同步 + 数据迁移
#   - 本地未提交改动（汉化等定制）会自动 git stash 备份，更新后自动 stash pop 恢复
#   - 依赖同步可能耗时几分钟

param(
    [switch]$CheckOnly,
    [switch]$Auto
)
$ErrorActionPreference = "Continue"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$venvPy = Join-Path $repo ".venv\Scripts\python.exe"
$port = 8675
Set-Location $repo

function Step($m) { Write-Host ""; Write-Host ("=" * 56); Write-Host "  $m"; Write-Host ("=" * 56) }
function Ok($m)   { Write-Host "[OK] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "[!] $m" -ForegroundColor Yellow }
function Err($m)  { Write-Host "[x] $m" -ForegroundColor Red }

function Get-VersionFromPy([string]$content) {
    if ($content -match 'VERSION\s*=\s*"([^"]+)"') { return $matches[1] }
    return "unknown"
}

Step "AI-Toolkit 一键更新（GitHub vs 本地）"

# ===== 0) 前置检查 =====
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Err "未找到 git。请先安装 git，或运行 python -m manager sync。"; exit 1 }
if (-not (Test-Path "$repo\.git")) { Err "$repo 不是 git 仓库。"; exit 1 }

$branch = (git rev-parse --abbrev-ref HEAD).Trim()
if ($LASTEXITCODE -ne 0) { Err "无法获取当前分支。"; exit 1 }
Write-Host "当前分支 : $branch"
$localVersion = Get-VersionFromPy ((Get-Content "$repo\version.py" -Raw -ErrorAction SilentlyContinue))
Write-Host "本地版本 : $localVersion"

# ===== 1) 从 GitHub 获取最新信息 =====
Write-Host ""
Write-Host "正在连接 GitHub 获取最新版本信息（请确保网络/代理可用）..."
git fetch origin 2>&1 | Out-Host
if ($LASTEXITCODE -ne 0) {
    Err "连接 GitHub 失败。请确认："
    Write-Host "  1. 代理软件已开启并监听本地端口"
    Write-Host "  2. 代理已配置： git config --global http.https://github.com.proxy http://127.0.0.1:<代理端口>"
    Write-Host "  3. 网络通畅后重新运行本脚本"
    exit 1
}
Ok "已获取 GitHub 上的最新版本信息。"

$remoteRef = "origin/$branch"
$localCommit  = (git rev-parse --short HEAD).Trim()
$remoteCommit = (git rev-parse --short "$remoteRef").Trim()
$remoteVersion = Get-VersionFromPy (((git show "$remoteRef`:version.py" 2>$null)) -join "`n")
$behind = [int]((git rev-list --count "HEAD..$remoteRef").Trim())
$ahead  = [int]((git rev-list --count "$remoteRef..HEAD").Trim())

$lInfo = (git log -1 --format="%ci|%s" HEAD).Trim() -split '\|'
$rInfo = (git log -1 --format="%ci|%s" "$remoteRef").Trim() -split '\|'

$porcelain = @(git status --porcelain)
$trackedDirty = @($porcelain | Where-Object { $_ -notmatch '^\?\?' })

# ===== 2) 显示版本对比 =====
Step "版本对比"
Write-Host ("  项目  : 本地 ($repo)          GitHub (ostris/ai-toolkit)")
Write-Host ("  版本  : {0,-14}         {1}" -f $localVersion, $remoteVersion)
Write-Host ("  Commit: {0,-14}         {1}" -f $localCommit, $remoteCommit)
if ($lInfo.Count -ge 2 -and $rInfo.Count -ge 2) {
    Write-Host ("  日期  : {0,-19}      {1}" -f $lInfo[0], $rInfo[0])
    Write-Host ("  说明  : {0}" -f $lInfo[1])
    Write-Host ("          {0}" -f $rInfo[1])
}
Write-Host ""
Write-Host "  本地落后 GitHub $behind 个提交，领先 $ahead 个提交。"
if ($trackedDirty.Count -gt 0) {
    Warn "  本地有 $($trackedDirty.Count) 个未提交的修改文件（汉化等定制）。"
} else {
    Write-Host "  本地无未提交的跟踪文件修改。"
}

# 展示即将更新的提交
if ($behind -gt 0) {
    Write-Host ""
    Write-Host "GitHub 上新增的提交（最多显示 15 条）："
    git log --oneline "HEAD..$remoteRef" --max-count=15 | ForEach-Object { Write-Host "    $_" }
}

# ===== 3) 判断是否需要更新 =====
if ($behind -eq 0) {
    Write-Host ""
    if ($ahead -gt 0) {
        Write-Host "本地领先 GitHub $ahead 个提交，无需更新。"
    } else {
        Ok "已是最新版本，无需更新。"
    }
    exit 0
}

if ($CheckOnly) {
    Write-Host ""
    Write-Host "检测完毕（仅检测模式）。需要更新时，运行本脚本并在询问时输入 Y。"
    exit 0
}

# ===== 4) 更新阶段 =====
Write-Host ""
$ans = if ($Auto) { "Y" } else { Read-Host "检测到更新，是否现在执行一键更新？[Y/N]" }
if ($ans -notmatch '^[Yy]') { Write-Host "已取消更新。"; exit 0 }

# 4.1 关闭正在运行的 UI
$uiListen = netstat -ano | Select-String ":8675" | Select-String "LISTENING"
if ($uiListen) {
    Write-Host ""
    Warn "检测到 UI 正在运行（端口 $port）。为避免文件占用导致更新失败，需先关闭。"
    $a2 = if ($Auto) { "Y" } else { Read-Host "是否自动关闭 UI？[Y/N]" }
    if ($a2 -match '^[Yy]') {
        Write-Host "正在关闭 UI..."
        & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repo "stop_ui.ps1")
    } else {
        Warn "请先手动关闭 UI（运行 stop_ui.bat）后重新运行本脚本。"
        exit 1
    }
}

# 4.2 保护本地改动（汉化等）
$stashed = $false
if ($trackedDirty.Count -gt 0) {
    Write-Host ""
    Warn "本地有 $($trackedDirty.Count) 个未提交的修改文件（汉化等定制）。"
    Write-Host "为保护这些改动，将自动暂存（git stash），更新完成后自动恢复（git stash pop）。"
    Write-Host "注意：若上游同时修改了相同文件，恢复时可能冲突，需手动解决。"
    $a3 = if ($Auto) { "Y" } else { Read-Host "是否继续（将自动备份本地改动）？[Y/N]" }
    if ($a3 -notmatch '^[Yy]') { Write-Host "已取消更新。"; exit 0 }
    Write-Host "正在暂存本地改动..."
    git stash push -m "ai-toolkit one-click update backup $(Get-Date -Format 'yyyyMMdd-HHmmss')" 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) { Err "git stash 失败，更新已中止。"; exit 1 }
    $stashed = $true
    Ok "本地改动已暂存备份。"
}

# 4.3 执行更新
Step "正在执行更新（git pull + 依赖同步 + 数据迁移）"
Write-Host "依赖同步可能需要几分钟，请耐心等待，不要关闭窗口..."
& $venvPy -m manager update
$updExit = $LASTEXITCODE
if ($updExit -ne 0) {
    Err "更新过程出错（退出码 $updExit），请查看上方日志。"
    if ($stashed) { Write-Host "提示：本地改动已暂存，可用 git stash list 查看，git stash pop 恢复。" }
    exit 1
}
Ok "更新命令执行完成。"

# 4.4 恢复本地改动
if ($stashed) {
    Step "正在恢复本地改动（git stash pop）"
    git stash pop 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) {
        Err "本地改动恢复时发生冲突！请手动处理："
        Write-Host "  查看冲突： git status"
        Write-Host "  解决冲突后保留汉化： git add .  ;  git stash drop"
        Write-Host "  放弃汉化保留上游： git checkout -- .  ;  git stash drop"
    } else {
        Ok "本地改动已恢复（汉化等定制保留）。"
    }
}

# ===== 5) 完成 =====
$newCommit = (git rev-parse --short HEAD).Trim()
$newVer = Get-VersionFromPy ((Get-Content "$repo\version.py" -Raw -ErrorAction SilentlyContinue))
Step "更新完成"
Write-Host "  新版本 : $newVer"
Write-Host "  新 commit: $newCommit"
Write-Host "  启动 UI:  cd $repo  &&  python -m manager launch"
Write-Host "  浏览器 :  http://localhost:$port"
Write-Host ""
