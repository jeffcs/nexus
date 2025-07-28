# NEXUS Pattern System

> Capturing and reusing successful solutions across projects

## What Are Patterns?

Patterns are reusable solutions that have proven successful in real projects. They can be:
- Code snippets
- Architectural decisions
- Configuration templates
- Testing strategies
- Deployment approaches

## Pattern Format

Patterns are stored as JSON files in `vault/patterns/` with this structure:

```json
{
  "id": "unique-pattern-id",
  "name": "Human-readable pattern name",
  "version": "1.0.0",
  "category": "testing|architecture|deployment|etc",
  "description": "What this pattern solves",
  "context": "When to use this pattern",
  "source": {
    "project": "original-project-name",
    "discovered": "2025-07-28",
    "pr_numbers": [123, 456]
  },
  "applicability": {
    "project_types": ["web-app", "api", "cli"],
    "tech_stack": ["react", "node", "typescript"],
    "tags": ["testing", "e2e", "playwright"]
  },
  "implementation": {
    "files": {
      "path/to/file.js": "file content or template",
      "config/test.json": "{ config content }"
    },
    "dependencies": {
      "playwright": "^1.40.0"
    },
    "scripts": {
      "test:e2e": "playwright test"
    }
  },
  "variables": {
    "PROJECT_NAME": "Name of the project",
    "BASE_URL": "Application base URL"
  },
  "usage": "How to apply this pattern",
  "examples": ["Example implementation"],
  "learnings": "What we learned from this pattern"
}
```

## Pattern Categories

- **architecture**: System design patterns
- **testing**: Test frameworks and strategies
- **deployment**: CI/CD and infrastructure
- **security**: Authentication and authorization
- **performance**: Optimization techniques
- **development**: DX improvements
- **integration**: Third-party service patterns

## Pattern Lifecycle

1. **Discovery**: Found in project via `/nexus/learn`
2. **Extraction**: Pattern isolated and generalized
3. **Validation**: Tested in new contexts
4. **Promotion**: Added to blueprints if universally applicable
5. **Evolution**: Updated based on new learnings