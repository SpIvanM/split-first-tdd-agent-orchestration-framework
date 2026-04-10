---
name: task-splitting
description: >
  Assess whether a coding task should be split, produce direct or reviewed split plans, and coordinate prompt packets, subagent dispatch, and TDD. Use when planning, decomposing, or delegating implementation work, including split, split2, task splitting, decomposition, subagent dispatch, дробление задачи, разбиение на подзадачи, or делегирование агентам.
---

# Task Splitting

Use this skill when a task may exceed one pass or when parallel work is possible.

## Output contract

Return:

- split_recommended
- split_mode
- review_required
- executor
- reviewer
- subtasks
- dependency_order
- verification
- fallback

## Decomposition rules

- Split by behavior, not by file count.
- Prefer one subtask per independent change.
- Use `split` when the decomposition is already safe for direct dispatch.
- Use `split2` when the plan needs critique before launch.
- Reject parallelization when two subtasks would touch the same lines.
- Do not split before the shared design decision is fixed.
- Keep implementation subtasks small enough for one red-green-refactor loop.
- Use read-heavy subtasks for discovery, review, and test selection.
- Use write-heavy subtasks only when ownership is disjoint.
- Build every implementation subtask prompt from `references/subtask-prompt-template.md`.
- Build every split2 review packet from `references/plan-review-template.md`.

## Execution rules

- Make the smallest failing test first for each implementation subtask.
- Verify each subtask with the narrowest useful command.
- Finish with a broader integration or diff review pass.
- For split2, revise the plan after reviewer feedback before dispatch.
- Surface ambiguity instead of guessing.