<!--
Name: split-first-manual-install
Description: Инструкция по ручной установке правил оркестрации в сторонние проекты.
-->

# 🛠 Manual Installation / Ручная установка

[🇷🇺 Перейти к русской версии](#russian) | [🇺🇸 Switch to English version](#english)

---

## <span id="russian"></span>🇷🇺 Инструкция по ручной установке

Если вы не можете использовать скрипты автоматической установки, следуйте этой инструкции для ручного внедрения правил.

### 1. Копирование файлов
Скопируйте следующие директории и файлы из этого репозитория в корень вашего проекта:

| Откуда (этот репозиторий) | Куда (ваш проект) | Описание |
| --- | --- | --- |
| `references/` | `references/` | Шаблоны промптов и ревизий |
| `agents/` | `agents/` | Скиллы декомпозиции |
| `.claude/agents/` | `.claude/agents/` | Роли для Claude Code |
| `.gemini/commands/` | `.gemini/commands/` | Команды для Gemini CLI |
| `tests/Validate-AgentPack.ps1` | `tests/Validate-AgentPack.ps1` | Валидатор правил |

### 2. Внедрение инструкций (Добавление)
Для следующих файлов необходимо скопировать содержимое из этого репозитория и вставить его в соответствующие файлы вашего проекта, обернув в маркеры.

**Маркеры:**
```markdown
<!-- ORCHESTRATION_START -->
... контент из этого репозитория ...
<!-- ORCHESTRATION_END -->
```

| Файл-источник | Целевой файл | Действие |
| --- | --- | --- |
| `AGENTS.md` | `AGENTS.md` | Вставьте в начало или конец файла |
| `CLAUDE.md` | `CLAUDE.md` | Вставьте в начало файла |
| `GEMINI.md` | `GEMINI.md` | Вставьте в начало файла |

### 3. Настройка .gitignore
Добавьте следующие шаблоны в ваш `.gitignore`, если они еще не добавлены:
```ignore
# Orchestration specific
.tmp/
.sandbox/
*.log
```

---

## <span id="english"></span>🇺🇸 Manual Installation Guide

If you cannot use the automated installation scripts, follow these steps to manually integrate the orchestration rules.

### 1. Copying Files
Copy the following directories and files from this repository to your project root:

| Source (this repo) | Destination (your project) | Description |
| --- | --- | --- |
| `references/` | `references/` | Prompt and review templates |
| `agents/` | `agents/` | Decomposition skills |
| `.claude/agents/` | `.claude/agents/` | Roles for Claude Code |
| `.gemini/commands/` | `.gemini/commands/` | Commands for Gemini CLI |
| `tests/Validate-AgentPack.ps1` | `tests/Validate-AgentPack.ps1` | Rule validator |

### 2. Injecting Instructions (Additive)
For the following files, copy the content from this repository and paste it into the corresponding files in your project, wrapped in markers.

**Markers:**
```markdown
<!-- ORCHESTRATION_START -->
... content from this repository ...
<!-- ORCHESTRATION_END -->
```

| Source File | Destination File | Action |
| --- | --- | --- |
| `AGENTS.md` | `AGENTS.md` | Paste at the top or bottom |
| `CLAUDE.md` | `CLAUDE.md` | Paste at the top |
| `GEMINI.md` | `GEMINI.md` | Paste at the top |

### 3. Git Ignore Setup
Add the following patterns to your `.gitignore` if they are not already present:
```ignore
# Orchestration specific
.tmp/
.sandbox/
*.log
```

---

## 📝 License
Distributed under the MIT License. See `LICENSE` for more information.