<!--
Name: split-first-orchestration-diagrams
Description: Сборник диаграмм (Workflow, Sequence, Use Case) для фреймворка split-first TDD оркестрации.
-->

# 📊 Диаграммы фреймворка

В этом файле собраны визуальные схемы, описывающие логику работы, взаимодействия и сценарии использования фреймворка.

---

## 🏗 Workflow (Процесс работы)

Эта диаграмма описывает жизненный цикл задачи от поступления до финального слияния (Merge).

```mermaid
graph TD
    classDef process fill:#f9f9f9,stroke:#333,stroke-width:1px
    classDef decision fill:#fff,stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    classDef terminator fill:#e1f5fe,stroke:#0288d1,stroke-width:2px
    classDef error fill:#ffebee,stroke:#c62828,stroke-width:1px

    StartNode(["Новая задача"]) --> SplitDec{"Требуется декомпозиция?"}
  
    SplitDec -- "Нет" --> Direct["Прямое выполнение"]
    Direct --> QueueCheck{"Есть задачи в очереди?"}
  
    SplitDec -- "Да" --> Plan1["1. Анализ сути задачи"]
  
    subgraph Phase1 ["Фаза 1: Оркестрация и Планирование"]
        Plan1 --> Plan2["2. Выбор архитектуры"]
        Plan2 --> Plan3["3. Формирование Плана v1"]
        Plan3 --> Plan4["4. Создание Prompt Packets"]
        Plan4 --> Split2Dec{"Нужна ревизия плана?"}
        Split2Dec -- "Да" --> Plan5["5. Ревизия плана другой моделью"]
        Plan5 --> Plan6["6. Утверждение списка задач"]
        Split2Dec -- "Нет" --> Plan6
    end
  
    Plan6 --> QueueCheck
  
    subgraph Phase2 ["Фаза 2: Исполнение и Контроль"]
        TaskSelect["Выбор следующей подзадачи"]
        ContextInit["Инициализация свежего контекста"]
    
        subgraph SubAgent ["Цикл Субагента: TDD"]
            RedPhase["Red: Написание теста"]
            GreenPhase["Green: Написание кода"]
            LocalTest{"Локальные тесты пройдены?"}
            LocalRetry{"> 10 попыток?"}
        
            MergeWork["Слияние в рабочую ветку"]
            GlobalTest{"Тесты проекта пройдены?"}
            GlobalRetry{"> 10 попыток?"}
        
            RedPhase --> GreenPhase
            GreenPhase --> LocalTest
            LocalTest -- "Нет" --> LocalRetry
            LocalRetry -- "Нет" --> GreenPhase
            LocalTest -- "Да" --> MergeWork
            MergeWork --> GlobalTest
            GlobalTest -- "Нет" --> GlobalRetry
            GlobalRetry -- "Нет" --> GreenPhase
        end
    end
  
    QueueCheck -- "Да" --> TaskSelect
    TaskSelect --> ContextInit
    ContextInit --> RedPhase
  
    Replan["♻️ Re-plan (Смена плана)"]
    LocalRetry -- "Да" --> Replan
    GlobalRetry -- "Да" --> Replan
    GlobalTest -- "Да" --> QueueCheck
  
    Replan --> Plan3
  
    QueueCheck -- "Нет" --> FinalRegression["Итоговый полный регресс"]
  
    subgraph Phase3 ["Фаза 3: Финал"]
        FinalRegression --> AllTestsSuccess{"Все тесты успешны?"}
        AllTestsSuccess -- "Нет" --> Replan
        AllTestsSuccess -- "Да" --> FinishNode(["Merge Ready (Успех)"])
    end

    class Direct,Plan1,Plan2,Plan3,Plan4,Plan5,Plan6,TaskSelect,ContextInit,RedPhase,GreenPhase,MergeWork,FinalRegression process
    class SplitDec,QueueCheck,Split2Dec,LocalTest,LocalRetry,GlobalTest,GlobalRetry,AllTestsSuccess decision
    class StartNode,FinishNode terminator
    class Replan error
```

---

## 🔄 Sequence Diagram (Линейный процесс взаимодействия)

Диаграмма последовательности показывает взаимодействие между Хостом (Планировщиком), Ревизором и Исполнителями.

```mermaid
sequenceDiagram
    autonumber
    actor User as Пользователь
    participant Host as Хост (Planner)
    participant Reviewer as Ревизор (split2)
    participant Executor as Исполнитель (SubAgent)
    participant Repo as Репозиторий (TDD)

    User->>Host: Запрос на сложную задачу
    Host->>Host: Анализ и Архитектура
    Host->>Host: Создание Plan.md и Prompt Packets
  
    alt Режим split2 (Ревизия)
        Host->>Reviewer: План на проверку
        Reviewer-->>Host: Правки и улучшения
        Host->>Host: Обновление плана
    end

    loop Для каждой подзадачи в Plan.md
        Host->>Executor: Prompt Packet (сфокусированный контекст)
        loop TDD Цикл
            Executor->>Repo: Написание теста (Red)
            Executor->>Repo: Код реализации (Green)
            Repo-->>Executor: Прогон тестов
        end
        Executor-->>Host: Результат и диффы
        Host->>Repo: Слияние подзадачи
    end

    Host->>Repo: Итоговый регресс-тест
    Repo-->>Host: Успех
    Host-->>User: Задача выполнена
```

---

## 🎯 Use Case Diagram (Сценарии использования)

Диаграмма описывает, какие задачи решает фреймворк для пользователя и агентов.

```mermaid
graph LR
    User([Пользователь])
    Agent([AI Агент])

    subgraph Framework ["Split-First Framework"]
        UC1("Декомпозиция сложной задачи")
        UC2("Изоляция контекста подзадач")
        UC3("Ревизия плана split2")
        UC4("Качество через TDD")
        UC5("Контроль регрессии")
    end

    User --> UC1
    User --> UC3
    Agent --> UC1
    Agent --> UC2
    Agent --> UC4
    Agent --> UC5
```
