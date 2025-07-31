# Nexus V2 User Guide

## Overview

Nexus V2 provides five specialized AI agents that work together to help you build software:

- **Product** - Research, strategy, and product management
- **Designer** - UI/UX design and user experience
- **Architect** - System design and technical architecture
- **Developer** - Code implementation and testing
- **Technician** - Debugging, DevOps, and operations

## Quick Start

Simply describe what you need in natural language. The appropriate agent will activate automatically.

### Examples

**Product Research:**
```
"Research best practices for user authentication"
"What features should we build for small businesses?"
"Is real-time sync worth implementing?"
```

**Design Work:**
```
"Design a user onboarding flow"
"How should users manage their settings?"
"Make this form more accessible"
```

**Architecture:**
```
"How should we structure the payment system?"
"Design the API for user management"
"What's the best database schema for this?"
```

**Development:**
```
"Implement the login feature"
"Write tests for the user service"
"Refactor this code for better performance"
```

**Operations:**
```
"Debug why the API is slow"
"Set up monitoring for the service"
"Optimize database queries"
```

## Agent Collaboration

Agents work together naturally. For complex tasks, they'll collaborate:

1. **Product** defines the need and requirements
2. **Designer** creates the user experience
3. **Architect** plans the technical approach
4. **Developer** implements the solution
5. **Technician** ensures it runs smoothly

## Best Practices

1. **Start with Why**: Let Product understand the problem first
2. **Iterate**: Agents will refine solutions through collaboration
3. **Be Specific**: Provide context and constraints
4. **Trust Expertise**: Let each agent excel in their domain

## Patterns

Each agent maintains patterns in `.nexus/patterns/[agent].md` that capture successful approaches. These grow over time as you use the system.

## Customization

Edit files in `.nexus/context/` to customize:
- `ideals.md` - Your project's values and principles
- `decisions.md` - Track important decisions
- `project.md` - Current project state

---

*For more details, see the individual agent files in `.nexus/agents/`*