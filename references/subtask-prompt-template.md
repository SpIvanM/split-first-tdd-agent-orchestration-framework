<!--
Name: Subtask Prompt Template
Description: Detailed prompt packet template for a single implementation subtask.
-->

# Subtask Prompt Template

Use this template for every implementation subtask.

## Objective

State the exact behavior this subtask must deliver.

## Context

Summarize the repository facts, user request, and relevant constraints.

## Scope

List the files, modules, or behaviors owned by this subtask.

## Non-goals

State what must not be changed in this subtask.

## Files

List only the files this subtask may edit.

## Dependencies

List other subtasks, decisions, or prerequisites that must land first.

## Constraints

Include any architectural, performance, or policy constraints.

## TDD Loop

- Write the failing test first.
- Implement the smallest code change that makes it pass.
- Re-run the narrowest useful verification.
- Refactor only while keeping tests green.

## Acceptance Criteria

State the observable behavior that means the subtask is done.

## Output Format

Return:
- status
- files changed
- tests run
- results
- remaining risks

## Stop Conditions

Stop and ask for help if the task is blocked by missing input, ambiguous scope, or overlapping file ownership.

## Self-check

Confirm that the prompt packet is specific enough for one executor to finish one TDD loop without inventing scope.