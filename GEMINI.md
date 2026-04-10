<!--
Name: Gemini Adapter
Description: Gemini CLI project instructions for split-first task planning, direct dispatch, split2 plan review, and verification around the shared agent contract.
-->
@AGENTS.md

# Gemini CLI Adapter

- Use `/plan` before implementation on broad tasks.
- Use `/split` to turn a broad task into executable subtask cards and dispatch them directly.
- Use `/split2` when the full plan should be reviewed before execution.
- Use `/review` before final delivery.
- Use `/test` to select the narrowest useful verification.
- Use `@references/orchestration-matrix.md` to route executor and reviewer models.
- Use `@references/subtask-prompt-template.md` for every implementation subtask prompt packet.
- Use `@references/plan-review-template.md` for the pre-dispatch review packet in `/split2`.
- Gemini-hosted execution dispatches implementation subtasks to `Codex GPT-5.4-mini super high`.
- Gemini-hosted `split2` sends the plan to `Codex GPT-5.4 xHigh` before dispatch.
- Prefer repo evidence over memory.
- Keep the host as controller; the executor should only work one subtask at a time.