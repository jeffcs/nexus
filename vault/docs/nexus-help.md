# NEXUS Comprehensive Help

## Quick Start

```bash
# Check system status
./nexus status

# Create a new project
/nexus/genesis web-app my-project

# Get help on any topic
/nexus/help [topic]
```

## Available Commands

### Core Commands
- `/nexus/help [topic]` - Show documentation
- `/nexus/evolve [version|guidance]` - Evolve the system
- `/nexus/spec <feature>` - Create feature specification
- `/nexus/init` - Initialize NEXUS in a project

### Agent Commands
- `/nexus/genesis` - Bootstrap new projects
- `/nexus/architect` - Design system architecture
- `/nexus/forge` - Generate implementation
- `/nexus/sentinel` - Quality assurance
- `/nexus/phoenix` - System recovery
- `/nexus/orchestrator` - Multi-agent coordination

### Workflow Commands
- Create specs with structured templates
- Execute specs with task tracking
- Use subagents for complex tasks

## Development Workflow

1. **Define** - Create spec with `/nexus/spec`
2. **Design** - Architecture with `/nexus/architect`
3. **Implement** - Code with `/nexus/forge`
4. **Validate** - Test with `/nexus/sentinel`

## Evolution

NEXUS can evolve through:
- Version upgrades: `/nexus/evolve 3.0`
- Guided evolution: `/nexus/evolve "add feature X"`

## Best Practices

1. Always start with a spec
2. Use appropriate agents for tasks
3. Document decisions
4. Follow established patterns
5. Evolve incrementally

## Getting Help

- `/nexus/help commands` - List all commands
- `/nexus/help agents` - Agent details
- `/nexus/help workflows` - Development workflows
- Check `vault/patterns/` for examples
