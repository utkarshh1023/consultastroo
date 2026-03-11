<#
Setup and push helper for Consultastro repo.
Usage examples:
  # Try automatic GH flow (preferred) and start auto-push watcher
  .\setup_and_push.ps1 -StartWatcher

  # Provide remote URL manually (HTTPS or SSH)
  .\setup_and_push.ps1 -RemoteUrl "git@github.com:utkarshh1023/Consultastroo.git" -StartWatcher

Notes:
- Requires Git installed and available in PATH.
- If using GitHub CLI (`gh`), the script will attempt to create the remote repo under the account `utkarshh1023`.
- For HTTPS pushes you may be prompted for credentials (use a PAT).
#>

param(
    [string]$RepoPath = (Get-Location).Path,
    [string]$RemoteUrl = '',
    [switch]$StartWatcher
)

Set-Location $RepoPath
Write-Host "Running setup_and_push in: $RepoPath"

function Fail([string]$msg) {
    Write-Host "ERROR: $msg" -ForegroundColor Red
    exit 1
}

# Ensure git exists
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail "git not found in PATH. Please install Git for Windows from https://git-scm.com/download/win or use 'winget install --id Git.Git' and re-run this script."
}

# Determine current branch or create main if none
$branch = ''
if (Test-Path .git) {
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
} else {
    Write-Host "No git repository detected. Initializing..."
    git init
    # Create initial commit if necessary
    git add -A
    if (-not [string]::IsNullOrWhiteSpace((git status --porcelain))) {
        git commit -m "Initial commit"
    } else {
        Write-Host "No changes to commit after init."
    }
    $branch = git rev-parse --abbrev-ref HEAD
}

# Ensure local git user is configured (set a sensible default if missing)
$gitName = git config --local user.name 2>$null
$gitEmail = git config --local user.email 2>$null
if (-not $gitName -or -not $gitEmail) {
    Write-Host "Local git user.name/user.email not set. Setting defaults (you can change these later)."
    $defaultName = $env:USERNAME
    $defaultEmail = "$($env:USERNAME)@local"
    git config --local user.name "$defaultName"
    git config --local user.email "$defaultEmail"
    Write-Host "Set git user.name to '$defaultName' and user.email to '$defaultEmail' (local repo config)."
}

if (-not $branch) { $branch = 'main' }
Write-Host "Current branch: $branch"

# If remote URL not supplied, try gh
if (-not $RemoteUrl) {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Write-Host "GitHub CLI found. Attempting to create or connect remote 'utkarshh1023/Consultastroo'..."
        try {
            gh auth status 2>$null
            # Create repo if it doesn't exist and push
            gh repo create utkarshh1023/Consultastroo --public --source . --remote origin --push --confirm
            $RemoteUrl = git remote get-url origin
            Write-Host "Remote set to: $RemoteUrl"
        } catch {
            Write-Host "gh create failed or not authenticated. You can provide RemoteUrl manually with -RemoteUrl. Error: $_"
        }
    }
}

# If still no remote, ask for one (non-interactive fallback will exit)
if (-not $RemoteUrl) {
    Write-Host "No remote configured. Please create a repo on GitHub named 'Consultastroo' under user 'utkarshh1023' or provide a remote URL via -RemoteUrl." -ForegroundColor Yellow
    Write-Host "Example:
  .\setup_and_push.ps1 -RemoteUrl 'https://github.com/utkarshh1023/Consultastroo.git' -StartWatcher"
    exit 0
}

# Configure remote if missing
$hasOrigin = $false
try { $originUrl = git remote get-url origin 2>$null; $hasOrigin = -not [string]::IsNullOrWhiteSpace($originUrl) } catch { $hasOrigin = $false }
if (-not $hasOrigin) {
    git remote add origin $RemoteUrl
    Write-Host "Added remote origin -> $RemoteUrl"
} else {
    # If a RemoteUrl was supplied and it's different, update it to avoid confusion
    if ($RemoteUrl -and ($originUrl -ne $RemoteUrl)) {
        Write-Host "Remote origin already set to: $originUrl`nBut a different RemoteUrl was provided. Updating origin to: $RemoteUrl"
        git remote set-url origin $RemoteUrl
        $originUrl = $RemoteUrl
    } else {
        Write-Host "Remote origin already set to: $originUrl"
    }
}

# Push branch
Write-Host "Pushing branch $branch to origin..."
try {
    git push -u origin $branch
    Write-Host "Push succeeded."
} catch {
    Write-Host "Push failed. You may need to authenticate (PAT for HTTPS or ensure SSH key is added). Error: $_"
}

# Optionally start watcher
if ($StartWatcher) {
    $pwshCmd = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($pwshCmd) {
        Start-Process -FilePath pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\auto_push.ps1" -WindowStyle Hidden
        Write-Host "Started auto_push.ps1 in background using pwsh."
    } else {
        Start-Process -FilePath powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\auto_push.ps1" -WindowStyle Hidden
        Write-Host "Started auto_push.ps1 in background using Windows PowerShell."
    }
}

Write-Host "Setup complete. Verify the repository at: $RemoteUrl"
Write-Host "Open the GitHub URL in a browser or run: git remote -v"

