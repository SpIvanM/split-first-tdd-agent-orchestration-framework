<!--
Name: Claude Adapter
Description: Claude Code project instructions for orchestrating subagents, keeping implementation tasks small, and enforcing the shared split-first and split2 review-before-dispatch contract.
-->

# Claude Code Adapter

This repo uses `AGENTS.md` as the canonical contract.

- Start broad work with the `orchestrator` subagent.
- Hand off to `planner` when you need concrete subtask cards.
- Hand off to `plan-reviewer` when the plan must be reviewed before launch.
- Use `debugger` for a failing test or reproducible bug.
- Use `tester` for narrow verification commands and result interpretation.
- Use `reviewer` for diffs before merge.
- Use `@references/orchestration-matrix.md` to route executor and reviewer models.
- Use `@references/subtask-prompt-template.md` for every implementation subtask prompt packet.
- Use `@references/plan-review-template.md` for split2 plan review.
- When Codex is the host, dispatch implementation subtasks to `Gemini 3 Flash`.
- When Codex is the host and split2 is required, review the plan in `Gemini 3.1 Pro high` before dispatch.
- Never let two subtasks edit the same lines at the same time.
- Keep implementation subtasks small enough for one red-green-refactor loop.
- When the task is too broad, split it before writing code.