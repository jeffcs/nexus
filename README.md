# Nexus V2: Agent-First Development

> Transform your development workflow with specialized AI agents that collaborate naturally

## What is Nexus V2?

Nexus V2 is a streamlined development framework built around specialized AI agents that collaborate to deliver exceptional software. Rather than rigid workflows or complex abstractions, Nexus provides clear agent roles that work together naturally.

## The Agent Collection

### 📊 Product Agent
**Role**: Product Manager + Researcher + Strategist  
**Purpose**: Research, strategy, and product validation  
**Responsibilities**:
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

### 🎨 Designer Agent
**Role**: UI/UX Designer + Design Systems Expert  
**Purpose**: Envisions and designs features that delight users  
**Responsibilities**:
- User experience design and flow
- Interface design and interaction patterns
- Accessibility and usability standards
- Visual design and branding consistency
- Design systems and component libraries

**Activation examples:**
- "Design a solution for..."
- "How should users interact with..."
- "What's the best UX for..."
- "Make this more accessible"

### 🏗️ Architect Agent
**Role**: System Designer + Technical Strategist  
**Purpose**: Designs robust, scalable technical solutions  
**Responsibilities**:
- System architecture and patterns
- Database design and data modeling
- API design and contracts
- Performance and scalability planning
- Security architecture

**Activation examples:**
- "How should we architect..."
- "Design the technical approach for..."
- "What's the best data model for..."
- "Plan the API structure for..."

### 💻 Developer Agent
**Role**: Builder + Analyst + Integrator  
**Purpose**: Implements solutions with craftsmanship and quality  
**Responsibilities**:
- Writing clean, maintainable code
- Following established patterns
- Test implementation
- API integration
- Code optimization and refactoring

**Activation examples:**
- "Implement..."
- "Build..."
- "Integrate with..."
- "Refactor..."
- "Write tests for..."

### 🔧 Technician Agent
**Role**: Debugger + DevOps + Production Specialist  
**Purpose**: Diagnoses and solves novel problems  
**Responsibilities**:
- Debugging complex issues
- Performance optimization
- Production operations
- Monitoring setup
- Security operations
- Deployment and infrastructure

**Activation examples:**
- "Debug..."
- "Investigate why..."
- "Fix production issue..."
- "Optimize performance..."
- "Set up monitoring for..."

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

## Collaboration Patterns

### Design → Architecture Dialog
When designing new features:
1. Designer proposes user experience
2. Architect evaluates technical feasibility
3. Both iterate until optimal solution emerges
4. Decisions documented automatically

### Architecture → Development Flow
When implementing:
1. Architect provides technical design
2. Developer implements following patterns
3. Continuous feedback on implementation challenges
4. Patterns extracted for future use

### Production → Technical Analysis
When issues arise:
1. Technician diagnoses the problem
2. Collaborates with Developer for fixes
3. Architect consulted for systemic issues
4. Learnings incorporated into patterns

## Directory Structure

### Source Repository (this project)
```
nexus/
├── agents/             # Agent source definitions
├── context/            # Context templates (agent + project)
├── evaluation/         # Evaluation system
├── install-nexus.sh    # Installation script
└── README.md           # Documentation
```

### After Installation (in your project)
```
your-project/
├── .claude/            # Claude Code configuration
│   ├── agents/         # Installed agents with context (gitignored)
│   └── settings.json   # Claude settings
├── .nexus/             # Runtime data (gitignored)
│   ├── context/        # Agent contexts (updatable)
│   │   ├── product.md  # Product agent knowledge
│   │   ├── designer.md # Designer agent knowledge
│   │   ├── architect.md # Architect agent knowledge
│   │   ├── developer.md # Developer agent knowledge
│   │   ├── technician.md # Technician agent knowledge
│   │   └── teacher.md  # Teacher agent knowledge
│   └── evaluation/     # Evaluation results
└── CLAUDE.md           # Project instructions
```

## Key Principles

### 1. Natural Collaboration
Agents work together through natural dialog, not rigid workflows. The Designer and Architect collaborate on feasibility. The Developer works from their combined output.

### 2. Context Awareness
Each agent deeply understands:
- Project mission and goals
- User needs and priorities
- Technical constraints
- Established patterns

### 3. Progressive Enhancement
- Start with simple agent interactions
- Add sophistication as needed
- Capture patterns through use
- Evolve based on results

### 4. Minimal Overhead
- No heavy documentation requirements
- Patterns captured automatically
- Decisions recorded through dialog
- Focus on delivering value

### 5. Quality Through Specialization
Each agent excels at their domain:
- Product ensures market fit
- Designer ensures delightful UX
- Architect ensures solid foundation
- Developer ensures quality implementation
- Technician ensures reliability

## Usage Examples

### Product Research
```
"Research best practices for user authentication"
"What features should we build for small businesses?"
"Is real-time sync worth implementing?"
```

### Design Work
```
"Design a user onboarding flow"
"How should users manage their settings?"
"Make this form more accessible"
```

### Architecture
```
"How should we structure the payment system?"
"Design the API for user management"
"What's the best database schema for this?"
```

### Development
```
"Implement the login feature"
"Write tests for the user service"
"Refactor this code for better performance"
```

### Operations
```
"Debug why the API is slow"
"Set up monitoring for the service"
"Optimize database queries"
```

### New Feature Development
```
You: "I need to add user notifications"

Product: [researches user needs and solutions]
Designer: [creates UX flow]
Architect: [designs system architecture]
Developer: [implements the feature]
Technician: [ensures production readiness]
```

### Teaching Agents
```
"teach product agent to use tldraw for mockups"
"teach architect to prefer Python for backend services"
"teach designer to always consider accessibility"
```

## Context System

Each agent has a comprehensive context file in `.nexus/context/[agent].md` that includes:
- Project understanding specific to their role
- Learned knowledge and insights
- Collaboration patterns with other agents
- Custom instructions from teaching

This context is automatically injected into agents during installation and can be updated:
- Using the teacher agent: "teach architect to use Python for backends"
- Manually editing context files in `.nexus/context/`
- The teacher agent updates both the context file AND the installed agent

The unified context system keeps all agent knowledge in one place per agent.

## Best Practices

1. **Be Specific**: Provide context and details
2. **Start with Why**: Let Product understand the problem first
3. **Iterate Naturally**: Build on agent responses
4. **Trust Expertise**: Let agents guide in their domains
5. **Capture Patterns**: Save successful solutions
6. **Collaborate**: Use multiple agents for complex tasks

## Integration with Claude Code

Nexus V2 uses Claude Code's official subagent system:
- Agents are defined in `.claude/agents/`
- Automatically loaded when Claude Code starts
- Natural language activation based on context
- Full access to Claude Code tools

The system uses Claude Code's `settings.json`:
- Project settings: `.claude/settings.json`
- Local settings: `.claude/settings.local.json` (gitignored)
- See [Claude Code settings documentation](https://docs.anthropic.com/en/docs/claude-code/settings)

## Success Metrics

- **Development Velocity**: Faster feature delivery
- **Code Quality**: Fewer bugs, better patterns
- **User Satisfaction**: Better UX through Designer agent
- **System Reliability**: Fewer production issues
- **Knowledge Growth**: Patterns captured and reused

## Contributing

Nexus V2 is open source. Contributions are welcome:
- Improve agent definitions
- Add new patterns
- Enhance documentation
- Share success stories

## License

MIT License - See LICENSE file for details

---

**Transform your development with intelligent agents. Install Nexus V2 today!**