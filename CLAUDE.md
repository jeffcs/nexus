# Nexus V2 Framework Development

## About This Repository

This is the source code for the Nexus V2 agent framework for Claude Code. The framework provides five specialized AI agents that work together to help developers build better software.

## IMPORTANT: Pattern Learning System

When using any Nexus agent, ALWAYS:
1. First check their learned patterns in `.nexus/patterns/[agent].md`
2. Apply these patterns to the agent's behavior
3. Consider the patterns as extensions of the agent's core capabilities

Example: Before using the product agent, check `.nexus/patterns/product.md` for any learned behaviors like "use tldraw for mockups" or "always check competitor features first".

## Critical Patterns (Enforced Immediately)

### Product Agent
- **Personal Framework**: Nexus is a personal developer framework for the maintainer only. Skip all market research, competitive analysis, and product marketing activities. Focus purely on solving the maintainer's specific development needs.

## Development Guidelines

When working on this codebase:

1. **Agent Quality**: Maintain exemplary agent definitions that showcase best practices
2. **Pattern Library**: Keep patterns concise, practical, and reusable
3. **Installation**: Ensure the installation process remains simple and reliable
4. **Documentation**: Keep all documentation clear and up-to-date
5. **Learning Integration**: Always check and apply patterns from `.nexus/patterns/`

## Project Structure

```
nexus/
├── agents/             # Source agent definitions
│   ├── product.md      # Product strategy and research
│   ├── designer.md     # UI/UX design
│   ├── architect.md    # System architecture
│   ├── developer.md    # Code implementation
│   ├── technician.md   # DevOps and debugging
│   └── teacher.md      # Teaching agent for patterns
├── context/            # Context templates
├── patterns/           # Pattern templates  
├── evaluation/         # Agent evaluation system
│   ├── nexus-eval.sh   # Main evaluation CLI
│   ├── hot-reload.sh   # Hot-reload for rapid iteration
│   ├── dashboard/      # Monitoring dashboard
│   └── lib/            # Evaluation libraries
├── archive/            # V1 system archive
├── install-nexus.sh    # Installation script
├── nexus.md           # User guide
├── README.md          # Main documentation
└── CLAUDE.md          # This file

After installation, these directories are created:
├── .claude/            # Claude Code configuration (gitignored)
│   └── agents/         # Installed agent copies
└── .nexus/             # Runtime data (gitignored)
    ├── context/        # Project-specific context
    ├── patterns/       # Learned patterns
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