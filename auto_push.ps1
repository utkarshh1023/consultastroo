# Auto-push watcher for Git (PowerShell)
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File .\auto_push.ps1
# Or run in background: Start-Process -FilePath pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\auto_push.ps1"

param(
    [string]$RepoPath = (Get-Location).Path,
    [int]$DebounceMs = 2000
)

Set-Location $RepoPath
Write-Host "Starting auto-push watcher in: $RepoPath"

$fsw = New-Object System.IO.FileSystemWatcher $RepoPath -Property @{ IncludeSubdirectories = $true; EnableRaisingEvents = $true }
$extensions = @('.java','.xml','.properties','.md','.yml','.yaml','.gradle','.pom','.kt','.js','.ts','.json')

# Exclude paths
$excludePatterns = @('\\.git\\','\\target\\')

# Debounce handling
$pending = $false
$timer = New-Object System.Timers.Timer $DebounceMs
$timer.AutoReset = $false
$timer.Add_Elapsed({
    if (-not $pending) { return }
    $pending = $false
    try {
        Write-Host "[auto_push] Debounced: staging and pushing changes..."
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Host "git not found in PATH. Exiting watcher."; return }
        git add -A
        $status = git status --porcelain
        if (-not [string]::IsNullOrWhiteSpace($status)) {
            $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            git commit -m "Auto commit: $timestamp"
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
            if (-not $branch) { $branch = 'main' }
            git push origin $branch
            Write-Host "[auto_push] Pushed changes to origin/$branch"
            # Optional log
            "$((Get-Date).ToString('o')) - pushed" | Out-File -FilePath "$RepoPath\.auto_push.log" -Append
        } else {
            Write-Host "[auto_push] Nothing to commit."
        }
    } catch {
        Write-Host "[auto_push] Error during auto-push: $_"
    }
}) | Out-Null

function ShouldHandleEvent($fullPath) {
    foreach ($pat in $excludePatterns) {
        if ($fullPath -match $pat) { return $false }
    }
    $ext = [IO.Path]::GetExtension($fullPath)
    if ($extensions -contains $ext) { return $true }
    # also handle pom.xml explicitly
    if ($fullPath -match "(?i)pom\.xml$") { return $true }
    return $false
}

Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -Action {
    $e = $Event.SourceEventArgs
    if (ShouldHandleEvent($e.FullPath)) {
        $pending = $true
        $timer.Stop() | Out-Null
        $timer.Start() | Out-Null
    }
}
Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action {
    $e = $Event.SourceEventArgs
    if (ShouldHandleEvent($e.FullPath)) {
        $pending = $true
        $timer.Stop() | Out-Null
        $timer.Start() | Out-Null
    }
}
Register-ObjectEvent $fsw Deleted -SourceIdentifier FileDeleted -Action {
    $e = $Event.SourceEventArgs
    if (ShouldHandleEvent($e.FullPath)) {
        $pending = $true
        $timer.Stop() | Out-Null
        $timer.Start() | Out-Null
    }
}
Register-ObjectEvent $fsw Renamed -SourceIdentifier FileRenamed -Action {
    $e = $Event.SourceEventArgs
    if (ShouldHandleEvent($e.FullPath)) {
        $pending = $true
        $timer.Stop() | Out-Null
        $timer.Start() | Out-Null
    }
}

Write-Host "Watcher running. Press Ctrl+C to stop. Logs: $RepoPath\.auto_push.log"
while ($true) { Start-Sleep -Seconds 3600 }
