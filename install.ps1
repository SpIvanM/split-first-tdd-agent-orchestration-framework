<#
Name: Windows Orchestration Installer
Description: Injects and updates split-first orchestration rules into target project files (AGENTS.md, CLAUDE.md, GEMINI.md) without overwriting user-defined rules.
Usage: powershell -ExecutionPolicy Bypass -File install.ps1
#>

$ErrorActionPreference = 'Stop'

$REPO_RAW = "https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main"
$FILES = @("AGENTS.md", "CLAUDE.md", "GEMINI.md")
$MARKER_START = "<!-- ORCHESTRATION_START -->"
$MARKER_END = "<!-- ORCHESTRATION_END -->"

function Update-FileContent([string]$filePath, [string]$newContent) {
    if (-not $newContent) { return }
    $fullContent = ""
    if (Test-Path $filePath) {
        $fullContent = Get-Content -Raw $filePath -ErrorAction SilentlyContinue
    }

    $injectedContent = "$MARKER_START`r`n$newContent`r`n$MARKER_END"

    if ($fullContent -match "(?s)<!-- ORCHESTRATION_START -->.*?<!-- ORCHESTRATION_END -->") {
        # Update existing block
        $updatedContent = $fullContent -replace "(?s)<!-- ORCHESTRATION_START -->.*?<!-- ORCHESTRATION_END -->", $injectedContent
        Write-Host "Updating $filePath..."
    } else {
        # Prepend new block
        $updatedContent = "$injectedContent`r`n`r`n$fullContent"
        Write-Host "Installing to $filePath..."
    }

    Set-Content -Path $filePath -Value $updatedContent -Encoding utf8
}

foreach ($file in $FILES) {
    try {
        $url = "$REPO_RAW/$file"
        Write-Host "Downloading $url..."
        $content = Invoke-RestMethod -Uri $url
        Update-FileContent $file $content
    } catch {
        Write-Warning "Failed to download $file: $($_.Exception.Message)"
    }
}

Write-Host "Orchestration rules installed successfully."