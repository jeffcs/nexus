# nexus/learn

Analyze project evolution and capture learnings as patterns or blueprint updates.

## Usage

```
/nexus/learn [specific area or feature to analyze]
```

## Purpose

This command analyzes your project's git history and changes since NEXUS initialization to:
- Identify innovations worth sharing
- Extract reusable patterns
- Update blueprints with improvements
- Feed learnings back to NEXUS

## Process

1. **Diff Analysis** - Compare current state with initial NEXUS templates
2. **Innovation Detection** - Identify significant improvements
3. **Pattern Extraction** - Generalize solutions for reuse
4. **Blueprint Updates** - Propose enhancements to templates
5. **Knowledge Capture** - Store learnings for future projects

## Examples

```
# Analyze all changes
/nexus/learn

# Focus on specific innovation
/nexus/learn our new playwright setup and make it a standard part of the nexus web-app blueprint

# Extract authentication pattern
/nexus/learn the auth system we built with Supabase

# Capture deployment improvements
/nexus/learn our GitHub Actions CI/CD workflow
```

## Output

Creates:
- Pattern files in `.nexus/patterns/` (local)
- Proposals for NEXUS pattern vault
- Blueprint update recommendations
- Learning report with metrics