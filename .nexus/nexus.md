# Using Nexus V2 Effectively

> Version: 2.0.0
> Purpose: Guide for leveraging Nexus agents in your development workflow

## Quick Start

Nexus V2 provides five specialized agents that work together to help you build exceptional software. Each agent is activated by natural language triggers.

### The Agents at a Glance

1. **Designer** 👨‍🎨 - Product/UX design
2. **Architect** 🏗️ - System design  
3. **Developer** 💻 - Implementation
4. **Technician** 🔧 - Debugging/DevOps
5. **Discovery** 🔍 - Research

## Activation Examples

### Designer Agent
- "Design a user flow for password reset"
- "How should users interact with the dashboard?"
- "What's the best UX for file uploads?"
- "Make this form more accessible"

### Architect Agent
- "How should we architect a real-time chat system?"
- "Design the data model for user permissions"
- "What's the best approach for handling file uploads?"
- "Plan the API structure for the mobile app"

### Developer Agent
- "Implement the user authentication flow"
- "Build a React component for data tables"
- "Integrate with the Stripe payment API"
- "Refactor this code for better performance"

### Technician Agent
- "Debug why the server is running slowly"
- "Investigate these 500 errors in production"
- "Fix the memory leak in the background worker"
- "Optimize database query performance"

### Discovery Agent
- "Research best practices for JWT authentication"
- "Find the best React table library"
- "Explore options for real-time synchronization"
- "What are alternatives to Redis for caching?"

## Collaboration Workflows

### New Feature Development
```
1. Discovery: "Research best practices for [feature]"
2. Designer + Architect: "Design a solution for [feature]"
3. Developer: "Implement [feature]"
4. Technician: "Ensure [feature] is production-ready"
```

### Bug Investigation
```
1. Technician: "Diagnose [issue]"
2. Developer: "Fix [issue]"
3. Architect: "Review if this indicates a systemic problem"
4. Designer: "Ensure the fix maintains good UX"
```

### Performance Optimization
```
1. Technician: "Profile and identify bottlenecks"
2. Architect: "Design optimization strategy"
3. Developer: "Implement optimizations"
4. Designer: "Verify UX isn't degraded"
```

## Best Practices

### 1. Be Specific
Instead of: "Make this better"
Try: "Improve the loading performance of the user list"

### 2. Provide Context
Instead of: "Design a form"
Try: "Design a form for users to update their billing information"

### 3. Iterate Naturally
Agents remember context within a conversation. Build on previous responses:
- "Now make it work on mobile"
- "Add error handling for that"
- "What about accessibility?"

### 4. Leverage Expertise
Each agent has deep knowledge in their domain:
- Ask Designer about UX patterns and accessibility
- Ask Architect about scalability and system design
- Ask Developer about implementation details
- Ask Technician about debugging and operations
- Ask Discovery about options and best practices

### 5. Cross-Agent Collaboration
Explicitly request collaboration when needed:
- "Designer and Architect: work together on this feature"
- "Developer: implement what Designer proposed"
- "Technician: review Developer's implementation for production readiness"

## Pattern Learning

Nexus agents learn from your project:
- They recognize your coding style
- They understand your architecture patterns
- They learn your design preferences
- They adapt to your workflow

This learning is stored in `.nexus/patterns/` and improves over time.

## Advanced Usage

### Multi-Agent Commands
You can activate multiple agents in one request:
- "Designer: create the UI flow, then Developer: show me how to implement it"

### Context Switching
Agents maintain context but you can explicitly switch:
- "Let's switch from debugging to designing a fix"

### Pattern Extraction
Ask agents to extract patterns:
- "What patterns do you see in our error handling?"
- "Document our component structure patterns"

### Knowledge Queries
Query accumulated knowledge:
- "What design patterns have we used successfully?"
- "Show me our established API patterns"

## Troubleshooting

### Agent Not Activating
- Check your trigger matches the examples
- Be more explicit: "Designer agent: ..."
- Provide more context about what you need

### Wrong Agent Responding
- Use explicit agent names when needed
- Clarify the type of help you need
- Rephrase to match agent specialties

### Collaboration Issues
- Break complex requests into steps
- Explicitly coordinate between agents
- Provide clear handoff points

## Configuration

### Project Context
Update `.nexus/context/project.md` with:
- Project goals and constraints
- Team preferences
- Technical requirements

### Ideals
Customize `.nexus/context/ideals.md` to reflect:
- Your team's values
- Quality standards
- Development philosophy

### Patterns
Patterns accumulate automatically in:
- `.nexus/patterns/design/` - UI/UX patterns
- `.nexus/patterns/architecture/` - System patterns
- `.nexus/patterns/code/` - Implementation patterns
- `.nexus/patterns/operations/` - DevOps patterns

## Tips for Success

1. **Start Simple**: Begin with single-agent requests
2. **Build Context**: Provide background in early interactions
3. **Iterate Often**: Refine through conversation
4. **Trust Expertise**: Let agents guide within their domains
5. **Learn Together**: The system improves with use

## Example Session

```
You: "I need to add a feature for users to export their data"

Discovery: [researches best practices for data export]

You: "Design a solution for data export"

Designer: [creates UX flow]
Architect: [evaluates technical approach]

You: "Implement the export feature"

Developer: [builds the feature following the design]

You: "Make sure this is production-ready"

Technician: [reviews performance, security, monitoring]
```

---

*Nexus V2 - Intelligent agents for exceptional development*