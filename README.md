# Consultastro — Local → GitHub Auto-Push

This repository contains the backend for Consultastro. You asked that whenever you update code locally, those changes are also updated on GitHub automatically. Below are safe, easy steps to configure the repo and a small PowerShell helper that watches the project and automatically commits + pushes changes.

---

## Quick overview
- Connect this local repo to a GitHub remote (HTTPS or SSH). See "Connect to GitHub" below.
- Optionally use `auto_push.ps1` to watch the project and automatically `git add`, `git commit` and `git push` after you save changes.

> Important: automatic commits are created with a generic message and push immediately. Review the script before use and adapt the commit message behavior to your workflow.

---

## 1) Connect to GitHub (pick one)

A) Using GitHub CLI (recommended if `gh` is installed):
```powershell
cd 'C:\Users\hp\OneDrive\Desktop\consultastro\consultastro'
# login if needed
gh auth login
# create remote and push (replace owner if needed)
gh repo create utkarshh1023/Consultastroo --public --source . --remote origin --push
```

B) Using HTTPS (Personal Access Token - PAT):
1. Create an empty repo on GitHub named `Consultastroo` under `utkarshh1023`.
2. In PowerShell:
```powershell
cd 'C:\Users\hp\OneDrive\Desktop\consultastro\consultastro'
git remote add origin https://github.com/utkarshh1023/Consultastroo.git
git push -u origin $(git branch --show-current)
```
When prompted for password, use a PAT with `repo` scope. Do not paste PAT in public places.

C) Using SSH (recommended for long-term):
1. Generate SSH key (if you don't have one):
```powershell
ssh-keygen -t ed25519 -C "your_email@example.com"
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
```
2. Add the public key to GitHub (https://github.com/settings/ssh/new).
3. Add remote and push:
```powershell
cd 'C:\Users\hp\OneDrive\Desktop\consultastro\consultastro'
git remote add origin git@github.com:utkarshh1023/Consultastroo.git
git push -u origin $(git branch --show-current)
```

---

## 2) Auto-push helper (PowerShell)
File: `auto_push.ps1` — this file is included in the repo. It uses a FileSystemWatcher, debounces changes, and when project files change it will run:
- `git add -A`
- `git commit -m "Auto commit: <timestamp>"` (only if there are staged changes)
- `git push origin <branch>`

How to run (background):
```powershell
# From repo root
cd 'C:\Users\hp\OneDrive\Desktop\consultastro\consultastro'
# Start the watcher in a background window (persistent):
Start-Process -FilePath pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\auto_push.ps1" -WindowStyle Hidden
```
If you don't have PowerShell Core (`pwsh`) use `powershell` instead, or run the script interactively:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\auto_push.ps1
```

Notes and safety:
- The script respects `.gitignore` because `git add -A` does.
- It commits automatically with a timestamp — change the commit message in the script if you prefer.
- If you want manual review, do not run this script; instead use a Git hook that prompts before push.

---

## 3) Recommended `.gitignore`
This project already contains a `.gitignore` tuned for Java/Maven. Please keep it.

---

## 4) Troubleshooting
- If `git` is not installed: install Git for Windows (https://git-scm.com) or use `winget install --id Git.Git`.
- If push fails (authentication): follow the chosen method's auth steps (gh login / configure PAT / add SSH key).
- If the auto script pushes unwanted files: stop the script (close window or kill process) and adjust `.gitignore` or the script filter.

---

If you want, I can run the commands here to create the remote and push (I'll need interactive auth via `gh`, PAT, or SSH key access). Tell me which option to use or run the `auto_push.ps1` yourself and I can adjust its behavior.

