<!--
Name: Orchestration Matrix
Description: Routing matrix for split and split2 workflows across Codex and Gemini hosts.
-->

# Orchestration Matrix

Use this matrix to route direct execution and split2 review-before-dispatch flows.

| Host | `split` executor | `split2` reviewer | `split2` executor |
| --- | --- | --- | --- |
| Codex | Gemini 3 Flash | Gemini 3.1 Pro high | Gemini 3 Flash |
| Gemini | Codex GPT-5.4-mini super high | Codex GPT-5.4 xHigh | Codex GPT-5.4-mini super high |

## Rules

- The host always keeps control.
- `split` is direct dispatch.
- `split2` adds a pre-dispatch review and revision pass.
- Every implementation subtask receives a prompt packet from `subtask-prompt-template.md`.
- Every `split2` plan receives a review packet from `plan-review-template.md`.
- The executor works one subtask at a time.
- The host verifies the output before moving on.