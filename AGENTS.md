<!--
Name: Shared Agent Contract
Description: Canonical repo contract for split-first orchestration, prompt packets, TDD execution, and pre-dispatch plan review across Codex, Gemini CLI, Claude Code, and Antigravity-style planners.
-->

# Shared Agent Contract

This file is the canonical behavior contract for all agents in this repo.

## Default flow

- split -> dispatch -> verify
- planner -> dispatcher -> verifier
- inspect the task before changing files
- decide whether the task needs split or split2
- use split for direct dispatch when the decomposition is already safe
- use split2 when the full plan should be reviewed before execution
- prefer one task card per subagent
- do not edit the same file in parallel
- if two subtasks touch the same lines, serialize them
- if the task needs one design decision before implementation, resolve that decision before splitting further

## Split criteria

Split when:

- independent files or behaviors are involved
- the work can be validated with separate tests
- the subtasks can be owned without overlap
- read-heavy investigation can happen in parallel

Do not split when:

- all changes land in one small file
- one shared state transition affects every subtask
- the main unknown is architectural, not operational
- the task is too small to justify orchestration

## Split modes

- `split` is the direct-dispatch mode.
- `split2` is the review-before-dispatch mode.
- `split2` must route the full plan through an opposite-provider reviewer before execution.
- The host routing matrix lives in `references/orchestration-matrix.md`.
- Every implementation subtask must receive a prompt packet from `references/subtask-prompt-template.md`.
- Every `split2` plan must be reviewed with `references/plan-review-template.md` before dispatch.

## TDD contract

- Every implementation subtask must start with a failing test or a clear reproduction.
- Keep each red-green-refactor loop small.
- Prefer the narrowest useful test command.
- If no test exists yet, create the smallest one that proves the behavior.
- Finish with a broader verification pass.

## Prompt contract

- Every implementation subtask prompt packet must include objective, context, scope, non-goals, files, dependencies, tests, acceptance criteria, output format, and stop conditions.
- Prompt packets must state the host model, executor model, and verifier model when relevant.
- Plan review packets must state the review scope, risk checks, and required revisions.
- Do not let the executor invent missing scope or test details.

## Dispatch contract

- Planner output must include goal, files, dependencies, tests, and done_when for every subtask.
- Read-heavy subtasks go first: repo discovery, diff review, failure reproduction, log inspection.
- Write-heavy subtasks stay serialized unless ownership is disjoint.
- Every task card must name a verifier.
- Use a subagent for each independent concern.
- Use split2 when the plan needs critique before launch.

## Reporting contract

- State assumptions explicitly.
- Quote exact commands and outcomes in the final report.
- If something is ambiguous, stop and surface the ambiguity instead of guessing.