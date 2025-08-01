# Nexus V2 Framework Development

## About This Repository

This is the source code for the Nexus V2 agent framework for Claude Code. The framework provides five specialized AI agents that work together to help developers build better software.

## IMPORTANT: Context System

The Nexus context system is already integrated into each agent. Agent contexts are injected during installation and contain:
- Project understanding and constraints
- Learned knowledge and insights
- Collaboration patterns
- Custom instructions

The teacher agent can update these contexts with new knowledge: "teach architect to use Python for backends"

## Critical Patterns (Enforced Immediately)

### Product Agent
- **Personal Framework**: Nexus is a personal developer framework for the maintainer only. Skip all market research, competitive analysis, and product marketing activities. Focus purely on solving the maintainer's specific development needs.

## Development Guidelines

When working on this codebase:

1. **Agent Quality**: Maintain exemplary agent definitions that showcase best practices
2. **Context System**: Keep context templates well-organized and comprehensive
3. **Installation**: Ensure the installation process remains simple and reliable
4. **Documentation**: Keep all documentation clear and up-to-date
5. **Learning Integration**: Context is automatically injected into agents during installation

## Project Structure

```
nexus/
├── agents/             # Source agent definitions
│   ├── product.md      # Product strategy and research
│   ├── designer.md     # UI/UX design
│   ├── architect.md    # System architecture
│   ├── developer.md    # Code implementation
│   ├── technician.md   # DevOps and debugging
│   └── teacher.md      # Teaching agent for knowledge
├── context/            # Context templates for all agents
│   ├── product.md      # Product agent context
│   ├── designer.md     # Designer agent context
│   ├── architect.md    # Architect agent context
│   ├── developer.md    # Developer agent context
│   ├── technician.md   # Technician agent context
│   └── teacher.md      # Teacher agent context
├── evaluation/         # Agent evaluation system
│   ├── nexus-eval.sh   # Main evaluation CLI
│   ├── hot-reload.sh   # Hot-reload for rapid iteration
│   ├── dashboard/      # Monitoring dashboard
│   └── lib/            # Evaluation libraries
├── archive/            # V1 system archive
├── install-nexus.sh    # Installation script
├── README.md          # Main documentation
└── CLAUDE.md          # This file (development guide)

After installation, these directories are created:
├── .claude/            # Claude Code configuration (gitignored)
│   └── agents/         # Installed agents with injected context
└── .nexus/             # Runtime data (gitignored)
    ├── context/        # Agent contexts (updatable by teacher)
    └── evaluation/     # Evaluation results and analytics
```

## The Agents

- **product**: Product strategy, research, and validation
- **designer**: UI/UX design and user experience
- **architect**: System design and technical architecture
- **developer**: Implementation and coding
- **technician**: Debugging, DevOps, and operations

## Making Changes

1. Edit agent definitions in `agents/[agent].md`
2. Update patterns in `patterns/[agent].md`
3. Update documentation as needed
4. Create PR with clear description

Remember: This framework should exemplify the best practices it promotes.