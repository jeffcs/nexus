---
description: Show comprehensive NEXUS documentation and available commands
allowed-tools: [Read]
argument-hint: [topic] (optional)
---

# NEXUS Help System

Show comprehensive documentation for NEXUS based on the requested topic.

Topic: $ARGUMENTS

## Available Topics:
- commands - List all available NEXUS commands
- agents - Detailed information about NEXUS agents
- evolution - How to evolve the system
- workflows - Spec-driven development workflows
- blueprints - Available project templates
- getting-started - Quick start guide

If no topic specified, show general overview.

@$NEXUS_ROOT/README.md
@$NEXUS_ROOT/vault/patterns/

Based on the topic, provide relevant documentation from:
1. System README and documentation
2. Agent descriptions
3. Command references
4. Pattern vault
5. Evolution guides

Format the output clearly with examples where appropriate.
