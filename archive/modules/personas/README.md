# NEXUS Persona Management

User personas guide design decisions by representing real user needs, goals, and constraints. NEXUS agents use personas to create features that truly serve users.

## Architecture

```
Persona System
    ├── Persona Manager
    │   ├── CRUD Operations
    │   ├── Active Persona Tracking
    │   └── Context Export
    ├── Persona Storage
    │   ├── Project Personas (.nexus/personas/)
    │   ├── Vault Archetypes (/vault/personas/archetypes/)
    │   └── Templates
    └── Agent Integration
        ├── Spec Generation
        ├── User Story Creation
        ├── Design Decisions
        └── Task Prioritization
```

## Persona Structure

Each persona includes:
- **Identity**: Name, age, occupation, technical level
- **Demographics**: Location, industry, company size
- **Goals**: Primary and secondary objectives
- **Pain Points**: Current frustrations and barriers
- **Behaviors**: Usage patterns and preferences
- **Needs**: Functional and emotional requirements
- **Scenarios**: Specific use cases and contexts
- **Constraints**: Technical and accessibility needs

## Using Personas

### 1. Create a Persona
```bash
/nexus/persona create "Sarah Chen" developer
# Edit the created persona file
```

### 2. Set Active Persona
```bash
/nexus/persona set sarah-chen
```

### 3. Generate User Stories
```bash
/nexus/persona story "implement search feature"
```

### 4. Use in Design
```bash
/nexus/designer "Create login form"
# Designer will consider active persona's needs
```

## Agent Integration

### Architect
- Considers persona technical level for complexity
- Designs systems matching user workflows
- Prioritizes based on persona goals

### Designer
- Creates interfaces for persona's skill level
- Addresses specific accessibility needs
- Optimizes for persona's devices/context

### Forge
- Generates code considering maintenance by persona
- Includes appropriate documentation level
- Implements features matching usage patterns

### Sentinel
- Tests scenarios from persona perspective
- Validates accessibility requirements
- Ensures error messages match technical level

## Archetypes

Pre-built personas for common user types:

### Developer
- Expert technical level
- Needs: Efficiency, automation, integration
- Pain points: Context switching, poor documentation

### Designer
- Intermediate technical level
- Needs: Visual tools, collaboration, handoff
- Pain points: Design-dev friction, maintaining systems

### Product Manager
- Intermediate technical level
- Needs: Visibility, analytics, alignment
- Pain points: Prioritization, measuring value

## Best Practices

1. **Start with Research**: Base personas on real user data
2. **Keep Current**: Update personas as users evolve
3. **Limit Quantity**: 3-5 personas maximum
4. **Make Them Real**: Use names, photos, quotes
5. **Focus on Goals**: Behaviors change, goals persist
6. **Test Assumptions**: Validate persona accuracy

## Integration Examples

### Spec Generation
```yaml
# Spec considers active persona
user_stories:
  - As a [persona.archetype]
  - I want to [feature]
  - So that I can [persona.primary_goal]
```

### Design Decisions
```yaml
# Design adapts to persona
interface:
  complexity: [based on persona.technical_level]
  devices: [persona.preferred_devices]
  accessibility: [persona.accessibility_needs]
```

### Task Prioritization
```yaml
# Tasks ordered by persona value
priority:
  high: [addresses persona.pain_points]
  medium: [supports persona.secondary_goals]
  low: [nice-to-have for persona]
```

## Commands

```bash
# Persona management
/nexus/persona create <name> [archetype]
/nexus/persona list
/nexus/persona set <id>
/nexus/persona get

# Using personas
/nexus/persona story <feature>
/nexus/architect <project> --persona <id>
/nexus/designer <interface> --persona <id>
```

Personas ensure every feature serves real human needs.