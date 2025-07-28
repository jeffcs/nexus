# nexus/pattern

Manage and apply NEXUS patterns - reusable solutions from successful projects.

## Usage

```
/nexus/pattern [command] [pattern-id]
```

## Commands

### list
Show all available patterns (local and vault)

### show <pattern-id>
Display detailed information about a pattern

### apply <pattern-id>
Apply a pattern to the current project

### create
Interactive pattern creation wizard

## Pattern System

Patterns are JSON files containing:
- Implementation files
- Dependencies
- Configuration
- Usage instructions
- Context and learnings

## Examples

```
# List all patterns
/nexus/pattern list

# Show Supabase auth pattern
/nexus/pattern show supabase-auth

# Apply a pattern
/nexus/pattern apply playwright-e2e

# Create new pattern
/nexus/pattern create
```

## Pattern Interpolation in Prompts

When working with AI agents, reference patterns:
- `@vault/patterns/supabase-auth` - Reference by path
- `Apply pattern supabase-auth` - Direct reference
- Patterns provide context for code generation