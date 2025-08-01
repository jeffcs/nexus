---
description: Create a specification for a new feature using structured workflow
allowed-tools: [Edit, Write, Read, Task]
argument-hint: <feature-description>
---

Create a detailed specification using NEXUS spec-driven workflow.

Feature: $ARGUMENTS

## Workflow:

1. **Create Spec Structure**
   - Use workflow engine to create spec directory
   - Based on @$NEXUS_ROOT/modules/workflows/specs/spec-template.md

2. **Define Requirements** (Can use Task tool)
   - Analyze feature requirements
   - Create user stories
   - Define scope and deliverables

3. **Technical Design** (Can use Task tool)
   - Architecture approach
   - Component breakdown
   - Integration points

4. **Task Breakdown**
   - Create detailed task list
   - Follow TDD approach
   - Estimate complexity

Use the Task tool for complex analysis:
```
Task(
  description="Analyze existing patterns for [feature]",
  subagent_type="general-purpose"
)
```

Store specifications in: `vault/specs/[date]-[feature-name]/`
