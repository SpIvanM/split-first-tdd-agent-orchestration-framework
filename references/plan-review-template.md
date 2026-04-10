<!--
Name: Plan Review Template
Description: Detailed review packet template for split2 plan critique and refinement before execution.
-->

# Plan Review Template

Use this template before dispatching split2 plans.

## Review Scope

Check decomposition quality, dependency order, overlap risk, executor routing, prompt completeness, TDD coverage, and TDD feasibility.

## Findings

List blocking and non-blocking findings separately.

## Required Revisions

Describe the smallest changes that make the plan safe to execute.

## Decision

Return one of:
- accept
- revise
- block

## Revised Plan

If the decision is revise, provide the corrected plan cards with dependencies, tests, and done_when fields.

## Self-check

Confirm that the revised plan is ready for direct dispatch without overlapping writes.