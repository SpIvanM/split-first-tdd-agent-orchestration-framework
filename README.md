<!--
Name: split-first-tdd-agent-orchestration-framework
Description: Каноническая постановка задачи, принципы, режимы split и split2, и критерии приемки для split-first оркестрации в Codex, Gemini CLI, Claude Code и Antigravity.
-->

# 🧩 Split-First TDD Agent Orchestration Framework

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Production](https://img.shields.io/badge/Status-Production-green.svg)](#)
[![Workflow: TDD](https://img.shields.io/badge/Workflow-TDD-blue.svg)](#)

[🇷🇺 Перейти к русской версии](#russian) | [🇺🇸 Switch to English version](#english)

---

## <span id="russian"></span>🇷🇺 Русский

Этот репозиторий фиксирует канонические правила для воркфлоу **split-first-tdd-agent-orchestration-framework**: как дробить большие задачи, как отправлять подзадачи во внешние инструменты, как делать предварительную ревизию плана и как проверять результат перед слиянием.

### 🌟 Обзор

Это слой координации, а не продуктовая функция и не общий планировщик. Набор правил помогает агенту:
- оценивать, нужно ли дробить большую задачу
- превращать задачу в независимые карточки подзадач
- передавать эти карточки нужному подагенту или CLI-точке входа
- формировать для каждой подзадачи развернутый prompt packet
- использовать TDD для подзадач, меняющих код
- проверять итоговый diff перед слиянием

### 📉 Проблема

Большие задачи на код ломаются, когда один агент пытается сделать все за один проход. Особенно это заметно при:
- маленьких лимитах дорогих моделей
- замусоренном контексте при последовательном исполнении

Типовые сбои: размывание контекста, поверхностное рассуждение, неверные предположения о состоянии репозитория, случайное параллельное редактирование, отсутствие тестов, дублирование работы из-за отсутствия декомпозиции по поведению.

### 🎯 Цели

Главная цель: поднять продуктивность агента внутри отведенного лимита за счет промпт-самоинженерии, снижения когнитивной нагрузки и детального планирования.
- снизить число ошибок на крупных кодовых задачах
- повысить глубину рассуждения за счет декомпозиции
- разделить чтение и запись по разным подзадачам
- сделать TDD режимом по умолчанию для implementation-подзадач
- держать каноническую политику в одном месте и добавить предрелизную ревизию плана

### 💡 Принципы

- Дробить по поведению, а не по числу файлов.
- Предпочитать одного владельца на одну подзадачу.
- Не параллелить пересекающиеся записи.
- Использовать read-heavy подзадачи для исследования и воспроизведения ошибок.
- Использовать write-heavy подзадачи только при раздельной ответственности.
- Применять TDD для каждой implementation-подзадачи (цикл red-green-refactor).
- Опираться на факты из репозитория, а не на память.
- Сначала проверять узко, потом шире.

### 🚀 Установка

Вы можете установить или обновить правила в своем проекте с помощью скриптов установки. Скрипты инъектируют инструкции воркфлоу в файлы `AGENTS.md`, `CLAUDE.md` и `GEMINI.md`, сохраняя ваши собственные правила. Также доступна [инструкция по ручной установке](MANUAL_INSTALL.md).

#### Windows (PowerShell)
```powershell
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/install.ps1" | Set-Content -Path install.ps1; powershell -ExecutionPolicy Bypass -File install.ps1; Remove-Item install.ps1
```

#### Linux / macOS (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/install.sh | bash
```

#### Удаление

Если вы решите удалить правила оркестрации:

##### Windows (PowerShell)
```powershell
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/uninstall.ps1" | Set-Content -Path uninstall.ps1; powershell -ExecutionPolicy Bypass -File uninstall.ps1; Remove-Item uninstall.ps1
```

##### Linux / macOS (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/uninstall.sh | bash
```

> [!IMPORTANT]
> Скрипты используют маркеры `<!-- ORCHESTRATION_START -->` и `<!-- ORCHESTRATION_END -->`. Содержимое внутри них будет перезаписано при обновлении. Ваши правила добавляйте выше или ниже этих маркеров.

### 🕹 Режимы

- **`/split`**: Используется, когда план надежен. Хост разбивает задачу на подзадачи с полными prompt packet и отправляет их на исполнение.
- **`/split2`**: План сначала отправляется на ревизию в модель другой платформы, обновляется, и только потом запускаются подзадачи.

#### Матрица запуска

| Хост | `/split` executor | `/split2` reviewer | `/split2` executor |
| --- | --- | --- | --- |
| Codex | Gemini 3 Flash | Gemini 3.1 Pro high | Gemini 3 Flash |
| Gemini | Codex GPT-5.4-mini super high | Codex GPT-5.4 xHigh | Codex GPT-5.4-mini super high |

### 🛠 Техническое задание и Структура

- `AGENTS.md` — источник истины.
- `GEMINI.md` и `CLAUDE.md` — адаптеры.
- `references/orchestration-matrix.md` — матрица хостов и исполнителей.
- `references/subtask-prompt-template.md` — шаблон prompt packet.
- `references/plan-review-template.md` — шаблон для ревизии плана.
- `agents/skills/task-splitting/SKILL.md` — контракт декомпозиции.
- Планировщик решает, нужно ли делить; Диспетчер создает карточки; Верификатор проверяет результат.

### ✅ Критерии приемки

- Большая задача оценивается на предмет разбиения за один проход.
- Разбитая задача дает независимые карточки с владельцами, файлами и тестами.
- Implementation-подзадачи выполняются маленькими TDD-циклами.
- `split2` не запускает подзадачи до завершения ревизии плана.

---

## <span id="english"></span>🇺🇸 English

This repository defines the canonical rules for the **split-first-tdd-agent-orchestration-framework**: how to decompose large tasks, dispatch subtasks to external tools, perform pre-flight plan reviews, and verify results before merging.

### 🌟 Overview

This is a coordination layer, not a product feature. The rule set helps the agent:
- assess whether a large task needs decomposition
- turn a task into independent subtask cards
- dispatch cards to the appropriate subagent or CLI entry point
- generate a comprehensive prompt packet for each subtask
- use TDD for subtasks involving code changes
- verify the final diff before merging

### 📉 The Problem

Large coding tasks break when a single agent tries to do everything in one pass. This is especially evident with:
- small limits of expensive models
- cluttered context during sequential execution

Typical failures: context dilution, shallow reasoning, incorrect assumptions about repo state, accidental parallel editing, lack of tests, duplicated work due to lack of behavioral decomposition.

### 🎯 Goals

The main goal: increase agent productivity within the allotted limit through prompt self-engineering, cognitive load reduction, and detailed planning.
- reduce error count on large code tasks
- increase reasoning depth through decomposition
- separate read and write operations into different subtasks
- make TDD the default mode for implementation subtasks
- keep the canonical policy in one place and add pre-release plan review

### 💡 Principles

- Decompose by behavior, not by file count.
- Prefer a single owner for each subtask.
- Do not parallelize overlapping writes.
- Use read-heavy subtasks for investigation and error reproduction.
- Use write-heavy subtasks only with separate responsibility.
- Apply TDD for every implementation subtask (red-green-refactor cycle).
- Rely on repository facts, not memory.
- Verify narrow first, then broad.

### 🚀 Installation

You can install or update the rules in your project using the installation scripts. These scripts inject workflow instructions into `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` while preserving your custom rules. A [manual installation guide](MANUAL_INSTALL.md) is also available.

#### Windows (PowerShell)
```powershell
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/install.ps1" | Set-Content -Path install.ps1; powershell -ExecutionPolicy Bypass -File install.ps1; Remove-Item install.ps1
```

#### Linux / macOS (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/install.sh | bash
```

#### Uninstallation

If you decide to remove the orchestration rules:

##### Windows (PowerShell)
```powershell
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/uninstall.ps1" | Set-Content -Path uninstall.ps1; powershell -ExecutionPolicy Bypass -File uninstall.ps1; Remove-Item uninstall.ps1
```

##### Linux / macOS (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main/uninstall.sh | bash
```

> [!IMPORTANT]
> Scripts use `<!-- ORCHESTRATION_START -->` and `<!-- ORCHESTRATION_END -->` markers. Content inside these will be overwritten during updates. Add your rules above or below these markers.

### 🕹 Modes

- **`/split`**: Used when the plan is reliable. The host splits the task into subtasks with full prompt packets and dispatches them.
- **`/split2`**: The plan is first sent for review to a model on another platform, updated, and only then the subtasks are launched.

#### Orchestration Matrix

| Host | `/split` executor | `/split2` reviewer | `/split2` executor |
| --- | --- | --- | --- |
| Codex | Gemini 3 Flash | Gemini 3.1 Pro high | Gemini 3 Flash |
| Gemini | Codex GPT-5.4-mini super high | Codex GPT-5.4 xHigh | Codex GPT-5.4-mini super high |

### 🛠 Technical Specifications & Structure

- `AGENTS.md` — Source of Truth.
- `GEMINI.md` and `CLAUDE.md` — Adapters.
- `references/orchestration-matrix.md` — Host and executor matrix.
- `references/subtask-prompt-template.md` — Prompt packet template.
- `references/plan-review-template.md` — Plan review template.
- `agents/skills/task-splitting/SKILL.md` — Decomposition contract.
- The Planner decides if splitting is needed; the Dispatcher creates cards; the Verifier checks the result.

### ✅ Acceptance Criteria

- High-level task is assessed for decomposition in one pass.
- Split task yields independent cards with owners, files, and tests.
- Implementation subtasks are completed in small TDD cycles.
- `split2` does not launch subtasks until the plan review is finished.

---

## 📝 License
Distributed under the MIT License. See `LICENSE` for more information.