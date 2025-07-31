# Nexus V2: Agent-First Development

> Transform your development workflow with specialized AI agents that collaborate naturally

## What is Nexus V2?

Nexus V2 is a specialized agent system for Claude Code that provides five expert agents working together:

- **📊 Product Agent** - Product strategy, research, and validation
- **🎨 Designer Agent** - UI/UX design and user experience
- **🏗️ Architect Agent** - System design and technical architecture
- **💻 Developer Agent** - Implementation and coding excellence
- **🔧 Technician Agent** - Debugging, DevOps, and operations

## Why Nexus V2?

Traditional AI assistants try to do everything, resulting in shallow knowledge across domains. Nexus V2 takes a different approach:

- **Deep Specialization**: Each agent is an expert in their field
- **Natural Collaboration**: Agents work together like a real team
- **Pattern Library**: Pre-built patterns that grow with usage
- **Zero Configuration**: Works immediately with natural language
- **Claude Code Native**: Built specifically for Claude Code sub-agents

## Quick Start

### Installation

1. Clone or download this repository
2. Navigate to your project directory
3. Run the installation script:

```bash
/path/to/nexus/install-nexus.sh
```

The installer will:
- Create the `.nexus` directory structure
- Install all five agents
- Configure Claude Code integration
- Set up the learning system
- Add usage documentation

### Basic Usage

Simply describe what you need in natural language:

```
"Design a user authentication flow"
"How should we architect a real-time chat?"
"Implement the payment processing feature"
"Debug why the API is returning 500 errors"
"Research best practices for caching"
```

The appropriate agent will automatically activate and help you.

## Agent Capabilities

### Product Agent 📊
- Product strategy and roadmaps
- Market and user research
- Feature prioritization
- Competitive analysis
- Idea validation

**Activation examples:**
- "Research best practices for..."
- "What features should we build for..."
- "Analyze the market for..."
- "Is it worth building..."

### Designer Agent 🎨
- User experience design
- Interface design
- Accessibility standards
- Design systems
- User flows

**Activation examples:**
- "Design a solution for..."
- "How should users interact with..."
- "What's the best UX for..."

### Architect Agent 🏗️
- System architecture
- Database design
- API design
- Performance planning
- Security architecture

**Activation examples:**
- "How should we architect..."
- "Design the technical approach for..."
- "What's the best data model for..."

### Developer Agent 💻
- Clean code implementation
- Test-driven development
- API integration
- Code optimization
- Refactoring

**Activation examples:**
- "Implement..."
- "Build..."
- "Integrate with..."
- "Refactor..."

### Technician Agent 🔧
- Debugging complex issues
- Performance optimization
- Production operations
- Monitoring setup
- Security operations

**Activation examples:**
- "Debug..."
- "Investigate why..."
- "Fix production issue..."
- "Optimize performance..."


## Advanced Features

### Agent Collaboration

Request multiple agents to work together:
```
"Designer and Architect: collaborate on a file upload feature"
```

### Pattern System

Each agent maintains their own pattern library:
- Product patterns for research and validation
- Design patterns for UI/UX
- Architecture patterns for systems
- Developer patterns for code
- Technician patterns for operations

### Context Awareness

Agents understand:
- Your project structure
- Technology stack
- Team preferences
- Previous decisions

## Directory Structure

After installation, your project will have:

```
.nexus/
├── agents/          # Agent definitions (copied from source)
├── patterns/        # Pattern libraries (copied from source)
├── context/         # Your project context (customizable)
└── nexus.md        # Usage guide

Source files (in this repo):
├── agents/          # Agent source definitions
├── patterns/        # Pattern examples
└── context/         # Context templates
```

## Customization

### Project Ideals
Edit `.nexus/context/ideals.md` to define your project's:
- Core values
- Development principles
- Quality standards
- Team philosophy

### Decision Log
Document important decisions in `.nexus/context/decisions.md`:
- Architectural choices
- Technology selections
- Design decisions
- Process changes

## Integration

### With Claude Code
Nexus V2 integrates seamlessly with Claude Code. The agents are automatically available in your Claude Code sessions.

### With Your Workflow
- Use during planning sessions
- Integrate with code reviews
- Support debugging sessions
- Enhance documentation

## Examples

### New Feature Development
```
You: "I need to add user notifications"

Product: [researches user needs and solutions]
Designer: [creates UX flow]
Architect: [designs system architecture]
Developer: [implements the feature]
Technician: [ensures production readiness]
```

### Debugging Session
```
You: "The app is crashing on mobile devices"

Technician: [analyzes the issue]
Developer: [implements fix]
Designer: [verifies UX isn't affected]
```

## Best Practices

1. **Be Specific**: Provide context and details
2. **Iterate Naturally**: Build on agent responses
3. **Trust Expertise**: Let agents guide in their domains
4. **Capture Patterns**: Save successful solutions
5. **Collaborate**: Use multiple agents for complex tasks

## Troubleshooting

### Agent Not Responding
- Use more specific triggers
- Explicitly name the agent: "Designer agent: ..."
- Check `.nexus/nexus.md` for examples

### Wrong Agent Activating
- Clarify your intent
- Use agent-specific keywords
- Name the desired agent explicitly

## Contributing

Nexus V2 is open source. Contributions are welcome:
- Improve agent definitions
- Add new patterns
- Enhance documentation
- Share success stories

## License

MIT License - See LICENSE file for details

## Support

- Read the full guide: `.nexus/nexus.md`
- Check agent definitions: `.nexus/agents/`
- Review patterns: `.nexus/patterns/`

---

**Transform your development with intelligent agents. Install Nexus V2 today!**