---
description: Evolve the NEXUS system
allowed-tools: [Bash, Edit, Read, Write]
argument-hint: [version] or "natural language guidance"
---

Run NEXUS evolution to upgrade the system:

!cd $NEXUS_ROOT && ./self/evolve/evolve.sh upgrade "$ARGUMENTS"

Evolution modes:
1. Version-based: `/nexus:evolve 2.0`
2. AI-guided: `/nexus:evolve "add feature X to all agents"`

The AI-guided mode allows natural language evolution requests.
