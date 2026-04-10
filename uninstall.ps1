<#
Name: Windows Orchestration Uninstaller
Description: Safely removes split-first orchestration rules and markers from project files.
Usage: powershell -ExecutionPolicy Bypass -File uninstall.ps1
#>

$ErrorActionPreference = 'Stop'

$FILES = @("AGENTS.md", "CLAUDE.md", "GEMINI.md")
$MARKER_START = "<!-- ORCHESTRATION_START -->"
$MARKER_END = "<!-- ORCHESTRATION_END -->"

function Uninstall-FileContent([string]$filePath) {
    if (-not (Test-Path $filePath)) { return }
    
    $fullContent = Get-Content -Raw $filePath
    if ($fullContent -match "(?s)<!-- ORCHESTRATION_START -->.*?<!-- ORCHESTRATION_END -->") {
        # Remove block and markers, plus one trailing newline if exists
        $updatedContent = $fullContent -replace "(?s)<!-- ORCHESTRATION_START -->.*?<!-- ORCHESTRATION_END -->[\r\n]*", ""
        $updatedContent = $updatedContent.Trim()
        
        if ([string]::IsNullOrWhiteSpace($updatedContent)) {
            Write-Host "File $filePath is now empty. Removing..."
            Remove-Item $filePath
        } else {
            Write-Host "Removing rules from $filePath..."
            Set-Content -Path $filePath -Value $updatedContent -Encoding utf8
        }
    }
}

foreach ($file in $FILES) {
    Uninstall-FileContent $file
}

Write-Host "Orchestration rules removed successfully."