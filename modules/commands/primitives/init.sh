#!/bin/bash
# NEXUS Init Command
# Initialize NEXUS in an existing project

NEXUS_ROOT="${NEXUS_ROOT:-$(pwd)/nexus}"

echo "🚀 Initializing NEXUS in current project..."

# Create .nexus directory
mkdir -p .nexus

# Create configuration
cat > .nexus/config.yaml << EOC
project: $(basename "$(pwd)")
created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
nexus_version: 1.0.0
agents:
  - genesis
  - architect
  - forge
EOC

# Create CLAUDE.md
cat > CLAUDE.md << 'EOC'
# Project Assistant Configuration

This project is enhanced with NEXUS - Neural Execution & eXperimentation Unified System.

## Available Commands

- `/nexus:genesis` - Bootstrap new components
- `/nexus:architect` - Design system architecture  
- `/nexus:forge` - Generate implementation code
- `/nexus:sentinel` - Run quality checks
- `/nexus:phoenix` - Fix and recover from issues

## Project Structure

[Project structure will be analyzed and added here]

## Development Workflow

1. Use `/spec` to create feature specifications
2. Use `/nexus:architect` to design the solution
3. Use `/nexus:forge` to implement
4. Use `/nexus:sentinel` to verify quality

---
*Powered by NEXUS v1.0.0*
EOC

echo "✅ NEXUS initialized successfully!"
echo "📝 Edit .nexus/config.yaml to customize"
echo "🚀 Use /nexus commands in Claude Code"
