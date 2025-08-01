#!/bin/bash
# NEXUS Evolution 3.0 - Help System & Agent OS Integration
# Based on guidance: Add help command and integrate Agent OS best practices

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

echo "🧬 Evolution 3.0: Help System & Agent OS Integration"
echo "=================================================="
echo ""
echo "This evolution will:"
echo "• Add comprehensive /nexus:help command"
echo "• Enhance agents with structured guidance from Agent OS"
echo "• Improve blueprints with spec-driven development"
echo "• Integrate Claude Code subagent features"
echo "• Add structured workflow patterns"
echo ""

# Step 1: Create the help command
echo "📚 Creating /nexus:help command..."

cat > "$NEXUS_ROOT/claude/commands/nexus:help.md" << 'EOF'
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
EOF

echo "   ✓ Created /nexus:help command"

# Step 2: Create structured spec system inspired by Agent OS
echo "📋 Creating spec-driven development system..."

mkdir -p "$NEXUS_ROOT/modules/workflows/specs"

cat > "$NEXUS_ROOT/modules/workflows/specs/spec-template.md" << 'EOF'
# Spec Requirements Document

> Spec: [SPEC_NAME]
> Created: [DATE]
> Status: Planning

## Overview

[1-2 sentence goal and objective]

## User Stories

### [Story Title]

As a [USER_TYPE], I want to [ACTION], so that [BENEFIT].

[Detailed workflow description]

## Spec Scope

1. **[Feature Name]** - [One sentence description]
2. **[Feature Name]** - [One sentence description]

## Out of Scope

- [Excluded functionality]

## Expected Deliverable

1. [Testable outcome]
2. [Testable outcome]

## Technical Specification

### Requirements
- [Specific technical requirement]

### Approach
- [Implementation approach]

### Dependencies
- [External dependencies with justification]
EOF

echo "   ✓ Created spec template"

# Step 3: Enhance agents with structured prompts
echo "🤖 Enhancing agents with structured guidance..."

# Enhanced Genesis agent
cat > "$NEXUS_ROOT/modules/agents/genesis/structured-prompt.md" << 'EOF'
# Genesis Agent - Structured Guidance

## Core Principles
- Start simple, evolve complexity
- Convention over configuration
- Enable rapid iteration
- Prepare for scale

## Workflow Steps

### 1. Project Analysis
- Understand project type and requirements
- Check for existing patterns in vault
- Identify appropriate blueprint

### 2. Structure Generation
- Create directory structure from blueprint
- Initialize configuration files
- Set up development environment

### 3. Documentation
- Generate README with setup instructions
- Create CLAUDE.md for AI context
- Document architectural decisions

### 4. Integration
- Set up version control
- Configure CI/CD basics
- Enable NEXUS commands

## Best Practices
- Always check existing patterns first
- Document decisions in .nexus/decisions.md
- Use consistent naming conventions
- Enable hot-reload where possible
EOF

# Enhanced Architect agent
cat > "$NEXUS_ROOT/modules/agents/architect/structured-prompt.md" << 'EOF'
# Architect Agent - Structured Guidance

## Core Principles
- Think in systems, not features
- Design for change
- Optimize for clarity
- Balance complexity with maintainability

## Design Process

### 1. Requirements Analysis
- Gather functional requirements
- Identify non-functional requirements
- Define system boundaries

### 2. Architecture Design
- Component breakdown
- Data flow diagrams
- Technology selection with rationale
- Integration points

### 3. Documentation
- Architecture Decision Records (ADRs)
- Component interaction diagrams
- Deployment architecture

## Deliverables
- System design document
- Component specifications
- Integration guidelines
- Performance considerations
EOF

echo "   ✓ Enhanced agent guidance"

# Step 4: Create workflow management system
echo "🔄 Creating workflow management system..."

cat > "$NEXUS_ROOT/modules/workflows/workflow-engine.sh" << 'EOF'
#!/bin/bash
# NEXUS Workflow Engine - Spec-driven development

create_spec() {
    local spec_name="$1"
    local spec_date=$(date +%Y-%m-%d)
    local spec_dir="$NEXUS_ROOT/vault/specs/$spec_date-$spec_name"
    
    mkdir -p "$spec_dir/sub-specs"
    
    # Copy template
    cp "$NEXUS_ROOT/modules/workflows/specs/spec-template.md" "$spec_dir/spec.md"
    
    # Create task breakdown
    cat > "$spec_dir/tasks.md" << 'TASKS'
# Spec Tasks

## Tasks

- [ ] 1. [Major task description]
  - [ ] 1.1 Write tests
  - [ ] 1.2 Implement feature
  - [ ] 1.3 Verify tests pass

- [ ] 2. [Major task description]
  - [ ] 2.1 Write tests
  - [ ] 2.2 Implement feature
TASKS
    
    echo "✅ Created spec: $spec_dir"
    echo "📝 Next: Edit $spec_dir/spec.md to define requirements"
}

execute_spec() {
    local spec_path="$1"
    local task_id="$2"
    
    if [ -f "$spec_path/tasks.md" ]; then
        echo "📋 Executing spec: $(basename "$spec_path")"
        echo "🎯 Task: $task_id"
        
        # Mark task as in progress
        sed -i '' "s/\[ \] $task_id/\[\*\] $task_id/" "$spec_path/tasks.md" 2>/dev/null
        
        echo "⚡ Task marked as in progress"
        echo "💡 Use appropriate agents to complete the task"
    fi
}

export -f create_spec execute_spec
EOF
chmod +x "$NEXUS_ROOT/modules/workflows/workflow-engine.sh"

echo "   ✓ Created workflow engine"

# Step 5: Enhanced blueprints with Agent OS patterns
echo "🏗️ Enhancing blueprints with structured patterns..."

# Enhanced web-app blueprint
cat > "$NEXUS_ROOT/factory/blueprints/web-app/structure.yaml" << 'EOF'
name: Web Application
version: 3.0.0
description: Structured web app with spec-driven development

directories:
  - .nexus/          # NEXUS configuration
  - .claude/         # Claude Code settings
  - app/             # Next.js app directory
  - components/      # React components
  - lib/             # Utilities and helpers
  - services/        # API services
  - hooks/           # Custom React hooks
  - types/           # TypeScript types
  - specs/           # Feature specifications
  - tests/           # Test files

files:
  - .nexus/config.yaml
  - .claude/settings.json
  - CLAUDE.md
  - README.md
  - package.json
  - tsconfig.json
  - next.config.js
  - .env.example

patterns:
  - Component-based architecture
  - Service layer pattern
  - Custom hooks for logic
  - Spec-driven development
  - Test-first approach
EOF

# Create CLAUDE.md template for projects
cat > "$NEXUS_ROOT/factory/blueprints/web-app/CLAUDE.md.template" << 'EOF'
# Project Assistant Configuration

This project uses NEXUS v3.0 with spec-driven development.

## Project Overview

[PROJECT DESCRIPTION]

## Development Workflow

1. **Create Spec**: Use `/nexus:spec` to define features
2. **Design**: Use `/nexus:architect` for system design  
3. **Implement**: Use `/nexus:forge` for implementation
4. **Validate**: Use `/nexus:sentinel` for quality checks

## Available Commands

- `/nexus:help` - Show comprehensive documentation
- `/nexus:spec` - Create feature specifications
- `/nexus:orchestrator` - Coordinate multi-agent tasks
- All standard NEXUS agent commands

## Project Structure

```
[PROJECT STRUCTURE]
```

## Current Specs

Active specs in `specs/` directory:
- [List active specs]

## Development Standards

Follow patterns in:
- @.nexus/standards/code-style.md
- @.nexus/standards/best-practices.md

---
*Powered by NEXUS v3.0 - Spec-driven development with AI agents*
EOF

echo "   ✓ Enhanced blueprints"

# Step 6: Create subagent integration
echo "🔗 Creating Claude Code subagent integration..."

cat > "$NEXUS_ROOT/modules/agents/subagent-handler.sh" << 'EOF'
#!/bin/bash
# NEXUS Subagent Handler for Claude Code Task tool

handle_subagent_task() {
    local task_type="$1"
    local task_description="$2"
    
    echo "🤖 Preparing subagent task: $task_type"
    
    case "$task_type" in
        "research")
            echo "Task: Research and analyze: $task_description"
            echo "Subagent will search through codebase and documentation"
            ;;
        "implement")
            echo "Task: Implement feature: $task_description"
            echo "Subagent will create implementation following patterns"
            ;;
        "test")
            echo "Task: Create tests for: $task_description"
            echo "Subagent will write comprehensive tests"
            ;;
        *)
            echo "Task: $task_description"
            ;;
    esac
}

export -f handle_subagent_task
EOF
chmod +x "$NEXUS_ROOT/modules/agents/subagent-handler.sh"

# Create spec command with subagent support
cat > "$NEXUS_ROOT/claude/commands/nexus:spec.md" << 'EOF'
---
description: Create a specification for a new feature using structured workflow
allowed-tools: [Edit, Write, Read, Task]
argument-hint: <feature-description>
---

Create a detailed specification using NEXUS spec-driven workflow.

Feature: $ARGUMENTS

## Workflow:

1. **Create Spec Structure**
   - Use workflow engine to create spec directory
   - Based on @$NEXUS_ROOT/modules/workflows/specs/spec-template.md

2. **Define Requirements** (Can use Task tool)
   - Analyze feature requirements
   - Create user stories
   - Define scope and deliverables

3. **Technical Design** (Can use Task tool)
   - Architecture approach
   - Component breakdown
   - Integration points

4. **Task Breakdown**
   - Create detailed task list
   - Follow TDD approach
   - Estimate complexity

Use the Task tool for complex analysis:
```
Task(
  description="Analyze existing patterns for [feature]",
  subagent_type="general-purpose"
)
```

Store specifications in: `vault/specs/[date]-[feature-name]/`
EOF

echo "   ✓ Created subagent integration"

# Step 7: Update help documentation
echo "📖 Creating comprehensive help documentation..."

mkdir -p "$NEXUS_ROOT/vault/docs"

cat > "$NEXUS_ROOT/vault/docs/nexus-help.md" << 'EOF'
# NEXUS Comprehensive Help

## Quick Start

```bash
# Check system status
./nexus status

# Create a new project
/nexus:genesis web-app my-project

# Get help on any topic
/nexus:help [topic]
```

## Available Commands

### Core Commands
- `/nexus:help [topic]` - Show documentation
- `/nexus:evolve [version|guidance]` - Evolve the system
- `/nexus:spec <feature>` - Create feature specification

### Agent Commands
- `/nexus:genesis` - Bootstrap new projects
- `/nexus:architect` - Design system architecture
- `/nexus:forge` - Generate implementation
- `/nexus:sentinel` - Quality assurance
- `/nexus:phoenix` - System recovery
- `/nexus:orchestrator` - Multi-agent coordination

### Workflow Commands
- Create specs with structured templates
- Execute specs with task tracking
- Use subagents for complex tasks

## Development Workflow

1. **Define** - Create spec with `/nexus:spec`
2. **Design** - Architecture with `/nexus:architect`
3. **Implement** - Code with `/nexus:forge`
4. **Validate** - Test with `/nexus:sentinel`

## Evolution

NEXUS can evolve through:
- Version upgrades: `/nexus:evolve 3.0`
- Guided evolution: `/nexus:evolve "add feature X"`

## Best Practices

1. Always start with a spec
2. Use appropriate agents for tasks
3. Document decisions
4. Follow established patterns
5. Evolve incrementally

## Getting Help

- `/nexus:help commands` - List all commands
- `/nexus:help agents` - Agent details
- `/nexus:help workflows` - Development workflows
- Check `vault/patterns/` for examples
EOF

echo "   ✓ Created help documentation"

# Step 8: Update system version
echo "📊 Updating system version..."

jq '.version = "3.0.0" | .codename = "Structured" | .released = now | .features += ["Comprehensive help system", "Spec-driven development", "Enhanced agent guidance", "Subagent integration", "Workflow engine", "Structured blueprints"]' \
    "$NEXUS_ROOT/self/dna/version.json" > "$NEXUS_ROOT/self/dna/version.json.tmp" && \
    mv "$NEXUS_ROOT/self/dna/version.json.tmp" "$NEXUS_ROOT/self/dna/version.json"

# Update Claude settings
cp "$NEXUS_ROOT/claude/settings/nexus-base.json" "$NEXUS_ROOT/.claude/settings.json"

echo ""
echo "✅ Evolution 3.0: Help System & Agent OS Integration complete!"
echo ""
echo "🚀 What's new in v3.0:"
echo "   • /nexus:help - Comprehensive documentation system"
echo "   • Spec-driven development workflow"
echo "   • Enhanced agents with structured guidance"
echo "   • Subagent integration for complex tasks"
echo "   • Improved blueprints and templates"
echo "   • Workflow engine for task management"
echo ""
echo "🎯 Try it out:"
echo "   /nexus:help - Show general documentation"
echo "   /nexus:help agents - Learn about agents"
echo "   /nexus:spec \"user authentication\" - Create a spec"
echo ""
echo "📚 NEXUS now incorporates the best of Agent OS!"

exit 0