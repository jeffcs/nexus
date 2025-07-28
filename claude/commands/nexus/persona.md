---
description: Create and manage user personas for design decisions
allowed-tools: [Bash, Edit, Write, Read, Glob, Grep, LS]
argument-hint: <create|list|set|get|story> [name] [archetype]
---

You are managing NEXUS user personas to guide design decisions.
Personas represent real users with specific needs, goals, and constraints.

Task: $ARGUMENTS

@nexus/modules/personas/persona-manager.sh
@nexus/modules/personas/README.md

Execute persona management based on the arguments:

1. **create <name> [archetype]**: Create a new persona
   - Use archetype if provided (developer, designer, product-manager)
   - Otherwise create from template
   - Guide user to edit the created file

2. **list**: Show all personas
   - Display project personas with active indicator
   - Show available archetypes

3. **set <persona-id>**: Set active persona
   - This persona will be used by default in specs and stories

4. **get**: Display active persona details
   - Show full persona definition

5. **story <feature> [persona-id]**: Generate user story
   - Create user story from persona perspective
   - Use active persona if ID not specified

6. **init**: Initialize persona system
   - Create necessary directories
   - Set up templates

Remember: Personas help ensure features serve real user needs.
When creating personas, encourage specificity and realism.