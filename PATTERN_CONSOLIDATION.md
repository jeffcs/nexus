# Pattern Consolidation Guide

## Overview

This guide explains how to consolidate learned patterns from `.nexus/patterns/` into the core agent definitions for better performance and consistency.

## When to Consolidate

Consolidate patterns when they:
- Have been in use for several weeks without issues
- Are fundamental to project success
- Apply to most or all use cases
- Have proven their value repeatedly

## Consolidation Process

### 1. Review Pattern Files

Check each agent's pattern file:
```bash
cat .nexus/patterns/product.md
cat .nexus/patterns/designer.md
cat .nexus/patterns/architect.md
cat .nexus/patterns/developer.md
cat .nexus/patterns/technician.md
```

### 2. Identify Stable Patterns

Look for patterns that:
- Have been added more than 30 days ago
- Are used frequently
- Haven't needed modification
- Are project-critical

### 3. Update Agent Definitions

For each stable pattern:

1. Open the agent definition: `agents/[agent].md`
2. Find the appropriate section
3. Integrate the pattern into the agent's core behavior
4. Remove the pattern from `.nexus/patterns/[agent].md`

### 4. Example Consolidation

**Pattern in `.nexus/patterns/architect.md`:**
```markdown
## Python Default for Backend
**Added**: 2025-01-01
**Pattern**: Always use Python with FastAPI for backend services unless there's a specific reason to use another language.
```

**Consolidated into `agents/architect.md`:**
```markdown
### Technology Selection

Default technology choices:
- **Backend**: Python with FastAPI (unless specific requirements dictate otherwise)
- **Database**: PostgreSQL for relational data
- **Cache**: Redis for session and cache storage
```

### 5. Update CLAUDE.md

Remove any pattern-specific instructions from CLAUDE.md that have been consolidated into agent definitions.

### 6. Archive Old Patterns

Create an archive of consolidated patterns:
```bash
mkdir -p .nexus/patterns/archive
cp .nexus/patterns/*.md .nexus/patterns/archive/
# Then clean up the active pattern files
```

## Benefits of Consolidation

1. **Performance**: Agents don't need to check external files
2. **Reliability**: Patterns are always available
3. **Clarity**: Core behaviors are documented in one place
4. **Version Control**: Agent definitions track all changes

## Maintaining Balance

Keep the pattern system for:
- New, experimental patterns
- Project-specific overrides
- Temporary behaviors
- Rapid iteration needs

Consolidate patterns that:
- Define fundamental behaviors
- Apply universally
- Have proven stable
- Improve agent effectiveness

## Automation Opportunity

Consider creating a consolidation script that:
1. Analyzes pattern age and usage
2. Suggests patterns for consolidation
3. Creates pull requests with updates
4. Archives consolidated patterns

This maintains the benefits of both dynamic learning and stable agent definitions.