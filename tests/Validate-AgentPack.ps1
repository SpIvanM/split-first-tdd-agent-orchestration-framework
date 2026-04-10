<#
Name: Agent Pack Validator
Description: Validates the Russian README, split and split2 orchestration rules, and the shared prompt templates.
Usage: Run from repo root after editing the orchestration pack.
Behavior: Fails if required files are missing or if the split-first contract drifts.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredFiles = @(
  'README.md',
  'AGENTS.md',
  'GEMINI.md',
  'CLAUDE.md',
  'agents/skills/task-splitting/SKILL.md',
  '.codex/skills/task-splitting/SKILL.md',
  '.claude/skills/task-splitting/SKILL.md',
  '.claude/agents/orchestrator.md',
  '.claude/agents/planner.md',
  '.claude/agents/plan-reviewer.md',
  '.claude/agents/reviewer.md',
  '.claude/agents/debugger.md',
  '.claude/agents/tester.md',
  '.gemini/commands/plan.toml',
  '.gemini/commands/split.toml',
  '.gemini/commands/split2.toml',
  '.gemini/commands/review.toml',
  '.gemini/commands/fix.toml',
  '.gemini/commands/test.toml',
  '.gemini/commands/plan.toml.meta.md',
  '.gemini/commands/split.toml.meta.md',
  '.gemini/commands/split2.toml.meta.md',
  '.gemini/commands/review.toml.meta.md',
  '.gemini/commands/fix.toml.meta.md',
  '.gemini/commands/test.toml.meta.md',
  'references/orchestration-matrix.md',
  'references/subtask-prompt-template.md',
  'references/plan-review-template.md'
)

function Assert-Contains {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string[]]$Needles
  )

  $text = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
  foreach ($needle in $Needles) {
    if ($text -notmatch [regex]::Escape($needle)) {
      throw "File '$Path' is missing expected text: $needle"
    }
  }
}

function New-TextFromCodePoints {
  param([Parameter(Mandatory = $true)][int[]]$CodePoints)

  return -join ($CodePoints | ForEach-Object { [char]$_ })
}

$headingProblem = '## ' + (New-TextFromCodePoints @(0x041F,0x0440,0x043E,0x0431,0x043B,0x0435,0x043C,0x0430))
$headingGoals = '## ' + (New-TextFromCodePoints @(0x0426,0x0435,0x043B,0x0438))
$headingPrinciples = '## ' + (New-TextFromCodePoints @(0x041F,0x0440,0x0438,0x043D,0x0446,0x0438,0x043F,0x044B))
$headingSpec = '## ' + (New-TextFromCodePoints @(0x0422,0x0435,0x0445,0x043D,0x0438,0x0447,0x0435,0x0441,0x043A,0x043E,0x0435,0x0020,0x0437,0x0430,0x0434,0x0430,0x043D,0x0438,0x0435))
$headingModes = '## ' + (New-TextFromCodePoints @(0x0420,0x0435,0x0436,0x0438,0x043C,0x044B))
$headingAcceptance = '## ' + (New-TextFromCodePoints @(0x041A,0x0440,0x0438,0x0442,0x0435,0x0440,0x0438,0x0438,0x0020,0x043F,0x0440,0x0438,0x0435,0x043C,0x043A,0x0438))
$sourceTruth = 'AGENTS.md ' + (New-TextFromCodePoints @(0x044F,0x0432,0x043B,0x044F,0x0435,0x0442,0x0441,0x044F,0x0020,0x0438,0x0441,0x0442,0x043E,0x0447,0x043D,0x0438,0x043A,0x043E,0x043C,0x0020,0x0438,0x0441,0x0442,0x0438,0x043D,0x044B))
$problemSmallLimits = New-TextFromCodePoints @(0x043C,0x0430,0x043B,0x0435,0x043D,0x044C,0x043A,0x0438,0x0435,0x0020,0x043B,0x0438,0x043C,0x0438,0x0442,0x044B,0x0020,0x0434,0x043E,0x0440,0x043E,0x0433,0x0438,0x0445,0x0020,0x043C,0x043E,0x0434,0x0435,0x043B,0x0435,0x0439)
$problemContextMess = New-TextFromCodePoints @(0x0437,0x0430,0x043C,0x0443,0x0441,0x043E,0x0440,0x0435,0x043D,0x043D,0x044B,0x0439,0x0020,0x043A,0x043E,0x043D,0x0442,0x0435,0x043A,0x0441,0x0442,0x0020,0x043F,0x0440,0x0438,0x0020,0x043F,0x043E,0x0441,0x043B,0x0435,0x0434,0x043E,0x0432,0x0430,0x0442,0x0435,0x043B,0x044C,0x043D,0x043E,0x043C,0x0020,0x0438,0x0441,0x043F,0x043E,0x043B,0x043D,0x0435,0x043D,0x0438,0x0438)
$mainGoal = New-TextFromCodePoints @(0x0413,0x043B,0x0430,0x0432,0x043D,0x0430,0x044F,0x0020,0x0446,0x0435,0x043B,0x044C)
$promptSelfEngineering = New-TextFromCodePoints @(0x043F,0x0440,0x043E,0x043C,0x043F,0x0442,0x002D,0x0441,0x0430,0x043C,0x043E,0x0438,0x043D,0x0436,0x0435,0x043D,0x0435,0x0440,0x0438,0x0438)
$cognitiveLoadReduction = New-TextFromCodePoints @(0x0441,0x043D,0x0438,0x0436,0x0435,0x043D,0x0438,0x044F,0x0020,0x043A,0x043E,0x0433,0x043D,0x0438,0x0442,0x0438,0x0432,0x043D,0x043E,0x0439,0x0020,0x043D,0x0430,0x0433,0x0440,0x0443,0x0437,0x043A,0x0438)
$contextManagement = New-TextFromCodePoints @(0x0443,0x043F,0x0440,0x0430,0x0432,0x043B,0x0435,0x043D,0x0438,0x044F,0x0020,0x043A,0x043E,0x043D,0x0442,0x0435,0x043A,0x0441,0x0442,0x043E,0x043C)
$detailedPlanning = New-TextFromCodePoints @(0x0434,0x0435,0x0442,0x0430,0x043B,0x044C,0x043D,0x043E,0x0433,0x043E,0x0020,0x043F,0x043B,0x0430,0x043D,0x0438,0x0440,0x043E,0x0432,0x0430,0x043D,0x0438,0x044F)
$decomposition = New-TextFromCodePoints @(0x0434,0x0435,0x043A,0x043E,0x043C,0x043F,0x043E,0x0437,0x0438,0x0446,0x0438,0x0438)
$plansUpTo30 = New-TextFromCodePoints @(0x043F,0x043B,0x0430,0x043D,0x044B,0x0020,0x0434,0x043E,0x0020,0x0033,0x0030,0x0020,0x043F,0x0443,0x043D,0x043A,0x0442,0x043E,0x0432)

foreach ($path in $requiredFiles) {
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing required file: $path"
  }
}

Assert-Contains 'README.md' @(
  'Codex',
  'Gemini CLI',
  'Claude Code',
  'Antigravity',
  $problemSmallLimits,
  $problemContextMess,
  $mainGoal,
  $promptSelfEngineering,
  $cognitiveLoadReduction,
  $contextManagement,
  $detailedPlanning,
  $plansUpTo30,
  $headingProblem,
  $headingGoals,
  $headingPrinciples,
  $headingSpec,
  $headingModes,
  $headingAcceptance,
  'split -> dispatch -> verify',
  'planner -> dispatcher -> verifier',
  'split2',
  'Gemini 3 Flash',
  'Gemini 3.1 Pro high',
  'GPT-5.4-mini super high',
  'GPT-5.4 xHigh',
  $sourceTruth
)

Assert-Contains 'AGENTS.md' @('split -> dispatch -> verify', 'split2', 'TDD', 'prompt packet', 'same file', 'subagent')
Assert-Contains 'GEMINI.md' @('@AGENTS.md', '/plan', '/split', '/split2', '/review', 'Codex GPT-5.4-mini super high', 'Codex GPT-5.4 xHigh')
Assert-Contains 'CLAUDE.md' @('AGENTS.md', 'orchestrator', 'planner', 'plan-reviewer', 'reviewer', 'debugger', 'tester', 'Gemini 3 Flash', 'Gemini 3.1 Pro high')
Assert-Contains 'agents/skills/task-splitting/SKILL.md' @('split', 'split2', 'dispatch', 'verify', 'red-green-refactor', 'prompt packet', 'TDD')
Assert-Contains '.codex/skills/task-splitting/SKILL.md' @('split', 'split2', 'dispatch', 'verify')
Assert-Contains '.claude/skills/task-splitting/SKILL.md' @('split', 'split2', 'dispatch', 'verify')

foreach ($path in @('.claude/agents/orchestrator.md', '.claude/agents/planner.md', '.claude/agents/plan-reviewer.md', '.claude/agents/reviewer.md', '.claude/agents/debugger.md', '.claude/agents/tester.md')) {
  Assert-Contains $path @('name:', 'description:')
}

Assert-Contains '.gemini/commands/split2.toml' @('description =', 'prompt =', '/split2', 'review', 'Gemini 3.1 Pro high', 'GPT-5.4-mini super high')

foreach ($path in @('.gemini/commands/plan.toml.meta.md', '.gemini/commands/split.toml.meta.md', '.gemini/commands/split2.toml.meta.md', '.gemini/commands/review.toml.meta.md', '.gemini/commands/fix.toml.meta.md', '.gemini/commands/test.toml.meta.md')) {
  Assert-Contains $path @('Name:', 'Description:')
}

Assert-Contains 'references/orchestration-matrix.md' @('split', 'split2', 'Gemini 3 Flash', 'Gemini 3.1 Pro high', 'GPT-5.4-mini super high', 'GPT-5.4 xHigh')
Assert-Contains 'references/subtask-prompt-template.md' @('Objective', 'Context', 'Scope', 'Non-goals', 'Constraints', 'Tests', 'Acceptance criteria', 'Output format', 'Stop conditions')
Assert-Contains 'references/plan-review-template.md' @('Review scope', 'decomposition', 'dependencies', 'overlap risk', 'TDD coverage', 'revise')

Write-Host 'Validation passed.'