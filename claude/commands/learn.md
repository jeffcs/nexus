# nexus/learn

Teach Nexus agents new patterns and behaviors through simple, natural language instructions.

## Usage

```
/nexus/learn
```

The command will prompt you for:
1. **What to learn**: Describe the new pattern or behavior
2. **Which agent**: The system will determine which agent should learn this

## Examples

Simple learnings:
```
"product agent should always consult the product mission before research"
"architect should use Python by default for backend services"
"designer should prioritize accessibility in all UI decisions"
"developer should write tests before implementation"
"technician should check logs first when debugging"
```

Complex patterns:
```
"when designing forms, always include proper validation and error states"
"for API design, follow REST conventions unless GraphQL is explicitly needed"
"use feature flags for gradual rollouts of new functionality"
```

## How It Works

1. **Natural Language**: Just describe what should be learned
2. **Agent Detection**: The system identifies which agent should learn
3. **Pattern Storage**: Learning is added to `nexus-patterns/[agent].md`
4. **Immediate Effect**: The pattern is available to the agent right away

## Pattern Format

Learnings are stored as markdown entries:
```markdown
## [Learning Title]
**Added**: [Date]
**Pattern**: [Your learning description]
```

## Best Practices

- Keep learnings concise and actionable
- Focus on "what" and "when", not implementation details
- Use positive framing ("do this") rather than negative ("don't do that")
- One learning per command for clarity