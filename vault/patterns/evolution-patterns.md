# NEXUS Evolution Patterns

## Evolution Types

### 1. Version-Based Evolution
Traditional numbered evolutions with predefined changes.
```bash
./self/evolve/evolve.sh upgrade 2.0
```

### 2. Guided Evolution
AI-driven evolution from natural language requests.
```bash
./self/evolve/evolve.sh upgrade "add error handling to all agents"
```

## Creating Evolutions

### Manual Evolution Script
1. Create script in `self/evolve/evolutions/`
2. Name format: `{version}-{name}.sh`
3. Update version in script
4. Document changes

### AI-Generated Evolution
1. Use `/nexus/evolve "description"`
2. System creates guidance file
3. Use `/nexus/architect` to design
4. Use `/nexus/forge` to implement

## Evolution Best Practices

1. **Atomic Changes**: One concept per evolution
2. **Backwards Compatible**: Don't break existing functionality
3. **Documentation**: Update all affected docs
4. **Testing**: Verify changes work correctly
5. **Rollback Plan**: Know how to undo changes

## Common Evolution Requests

- "Add logging to all agents"
- "Create new agent type X"
- "Enhance error handling"
- "Optimize performance"
- "Add new project template"
