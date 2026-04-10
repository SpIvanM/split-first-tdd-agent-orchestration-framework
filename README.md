<!--
Name: Пакет оркестрации агентов
Description: Канонический README для split-first воркфлоу. Содержит принципы декомпозиции, инструкции по установке и контракт взаимодействия агентов.
-->

# 🧩 Split-First Agent Orchestration Framework

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Production](https://img.shields.io/badge/Status-Production-green.svg)](#)
[![Workflow: TDD](https://img.shields.io/badge/Workflow-TDD-blue.svg)](#)

> **EN**: A canonical set of rules for reliable task decomposition, subtask dispatch, and pre-release plan review.
> **RU**: Канонический набор правил для надежной декомпозиции задач, диспетчеризации и предварительной ревизии планов.

---

## 📖 Contents / Оглавление
- [Overview / Обзор](#-overview--обзор)
- [Installation / Установка](#-installation--установка)
- [Workflow / Процесс](#-workflow--процесс)
- [Modes / Режимы](#-modes--режимы)
- [Project Structure / Структура проекта](#-project-structure--структура-проекта)
- [Adopters / Адаптеры](#-adopters--адаптеры)

---

## 🌟 Overview / Обзор

**EN**: Large coding tasks break when a single agent tries to do everything at once. This framework enforces a **split-first** workflow: decompose before implement, test before merge.
**RU**: Большие задачи ломаются, когда агент пытается сделать всё за один проход. Этот фреймворк навязывает **split-first** воркфлоу: декомпозиция перед реализацией, тесты перед слиянием.

### Why Split-First? / Почему Split-First?
- 🧠 **Context Hygiene**: Keeps agent focus sharp on small units. / Чистота контекста: фокус на малых задачах.
- 🛡️ **TDD First**: Mandatory tests for every implementation code change. / TDD по умолчанию: обязательные тесты.
- 🤝 **Multi-Agent**: Dispatch tasks between different LLMs and CLI tools. / Мульти-агентность: делегирование между моделями.

---

## 🚀 Installation / Установка

**EN**: Inject orchestration rules into your project while preserving your own custom instructions.
**RU**: Внедрите правила оркестрации в свой проект, сохраняя собственные инструкции.

### Windows (PowerShell)
`powershell
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/install.ps1" | Set-Content -Path install.ps1; powershell -ExecutionPolicy Bypass -File install.ps1; Remove-Item install.ps1
`

### Linux / macOS (Bash)
`ash
curl -fsSL https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/install.sh | bash
`

> [!IMPORTANT]
> **EN**: Rules are wrapped in <!-- ORCHESTRATION_START --> markers. Updates only affect marked content.
> **RU**: Правила обернуты в маркеры <!-- ORCHESTRATION_START -->. Обновления затронут только помеченный контент.

---

## 🛠 Workflow / Процесс

`mermaid
graph TD
    Start[User Request] --> Planner{Need Split?}
    Planner -- No --> Implementation[Direct Implementation]
    Planner -- Yes --> Decompose[Decomposition / Split]
    Decompose --> Dispatch[Subtask Dispatch]
    Dispatch --> TDD[TDD Implementation Loop]
    TDD --> Verify[Verification / Review]
    Verify --> Merge[Final Merge]
`

---

## 🕹 Modes / Режимы

### /split
- **EN**: Direct dispatch for reliable plans. / Прямая диспетчеризация надежных планов.
- **RU**: Разбиение на подзадачи и мгновенный запуск исполнения.

### /split2
- **EN**: Review-before-dispatch for complex tasks. / Ревизия плана перед запуском для сложных задач.
- **RU**: Декомпозиция -> Ревизия плана внешней моделью -> Исполнение.

---

## 📁 Project Structure / Структура проекта

- AGENTS.md: Source of truth / Источник истины.
- CLAUDE.md / GEMINI.md: Platform adapters / Адаптеры платформ.
- eferences/: Templates for prompts and reviews / Шаблоны промптов.
- .claude/ / .gemini/: Custom agent roles and slash-commands / Роли и команды.

---

## 🤖 Adopters / Адаптеры

- **Antigravity**: Native split-first support.
- **Gemini CLI**: /split, /split2, /review, /test.
- **Claude Code**: Specialized subagents (orchestrator, planner, 	ester).

---

## 📝 License

Distributed under the MIT License. See LICENSE for more information.