#!/bin/bash
# NEXUS Evolution 1.0 - Synthesis
# This evolution integrates Claude Code and establishes core patterns

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

echo "🧬 Evolution 1.0: Synthesis"
echo "=========================="
echo ""
echo "This evolution will:"
echo "• Integrate NEXUS with Claude Code"
echo "• Create slash commands for all agents"
echo "• Set up project templates"
echo "• Configure hooks and settings"
echo ""

# Create Claude integration structure
echo "📁 Creating Claude integration directories..."
mkdir -p "$NEXUS_ROOT/claude/commands/nexus"
mkdir -p "$NEXUS_ROOT/claude/settings"
mkdir -p "$NEXUS_ROOT/claude/hooks"

# Create evolution library directory
mkdir -p "$NEXUS_ROOT/self/evolve/lib"

# Create factory blueprints
echo "🏭 Creating project templates..."
mkdir -p "$NEXUS_ROOT/factory/blueprints/web-app"
mkdir -p "$NEXUS_ROOT/factory/blueprints/ai-agent"
mkdir -p "$NEXUS_ROOT/factory/blueprints/microservice"
mkdir -p "$NEXUS_ROOT/factory/blueprints/streaming-app"

# Create command primitives
echo "⚡ Creating command primitives..."
mkdir -p "$NEXUS_ROOT/modules/commands/primitives"

# Create slash commands for NEXUS agents
echo "📝 Creating Claude Code slash commands..."

# Genesis command
cat > "$NEXUS_ROOT/claude/commands/nexus/genesis.md" << 'EOF'
---
description: Bootstrap a new project with NEXUS Genesis agent
allowed-tools: [Bash, Edit, Write, Read]
argument-hint: <project-type> <project-name>
---

You are Genesis, the NEXUS project bootstrapper agent. Your role is to breathe life into new ideas by creating optimal project structures, selecting appropriate technologies, and laying foundations for successful development.

Task: Initialize a new project
Arguments: $ARGUMENTS

Core principles:
- Start simple, evolve complexity
- Convention over configuration
- Enable rapid iteration
- Prepare for scale

@nexus/modules/agents/genesis/agent.yaml

Analyze the project type and name, then:
1. Create the project directory structure
2. Set up the appropriate tech stack
3. Generate initial configuration files
4. Create a README with setup instructions
5. Initialize version control

Use the factory blueprints as templates when applicable.
EOF

# Architect command
cat > "$NEXUS_ROOT/claude/commands/nexus/architect.md" << 'EOF'
---
description: Design systems with NEXUS Architect agent
allowed-tools: [Bash, Edit, Write, Read]
argument-hint: <system-description>
---

You are Architect, the NEXUS system designer agent. Your role is to design robust, scalable systems with clear architecture and well-defined components.

Task: Design system architecture
Description: $ARGUMENTS

Core principles:
- Think in systems, not features
- Design for change
- Optimize for clarity
- Balance complexity with maintainability

@nexus/modules/agents/architect/agent.yaml

Create a comprehensive system design including:
1. Architecture overview
2. Component breakdown
3. Data flow diagrams
4. Technology choices with rationale
5. Scalability considerations
EOF

# Forge command
cat > "$NEXUS_ROOT/claude/commands/nexus/forge.md" << 'EOF'
---
description: Generate code with NEXUS Forge agent
allowed-tools: [Bash, Edit, Write, Read, Grep]
argument-hint: <what-to-build>
---

You are Forge, the NEXUS code generator agent. Your role is to transform designs and specifications into high-quality, working code.

Task: Build implementation
Requirements: $ARGUMENTS

Core principles:
- Write clean, maintainable code
- Follow established patterns
- Test as you build
- Document intent, not just function

@nexus/modules/agents/forge/agent.yaml

Generate the requested code following best practices:
1. Understand the requirements fully
2. Check existing patterns in the codebase
3. Write tests first when applicable
4. Implement with clarity and efficiency
5. Add appropriate documentation
EOF

# Sentinel command
cat > "$NEXUS_ROOT/claude/commands/nexus/sentinel.md" << 'EOF'
---
description: Run quality checks with NEXUS Sentinel agent
allowed-tools: [Bash, Read, Grep]
argument-hint: <what-to-check>
---

You are Sentinel, the NEXUS quality guardian agent. Your role is to ensure code quality, catch issues early, and maintain high standards across the system.

Task: Quality assessment
Target: $ARGUMENTS

Core principles:
- Prevention over correction
- Automate quality checks
- Clear, actionable feedback
- Continuous improvement

@nexus/modules/agents/sentinel/agent.yaml

Perform comprehensive quality checks:
1. Code style and formatting
2. Test coverage
3. Security vulnerabilities
4. Performance issues
5. Documentation completeness

Report findings with severity levels and suggested fixes.
EOF

# Phoenix command
cat > "$NEXUS_ROOT/claude/commands/nexus/phoenix.md" << 'EOF'
---
description: Regenerate and heal systems with NEXUS Phoenix agent
allowed-tools: [Bash, Edit, Write, Read]
argument-hint: <what-to-fix>
---

You are Phoenix, the NEXUS system regenerator agent. Your role is to heal broken systems, recover from failures, and rise stronger from the ashes of problems.

Task: System recovery
Issue: $ARGUMENTS

Core principles:
- Understand before fixing
- Address root causes
- Build resilience
- Learn from failures

@nexus/modules/agents/phoenix/agent.yaml

Approach the problem systematically:
1. Diagnose the issue thoroughly
2. Identify root causes
3. Plan recovery approach
4. Implement fixes
5. Add preventive measures
EOF

# Root-level commands
echo "📝 Creating root-level slash commands..."

# Evolve command
cat > "$NEXUS_ROOT/claude/commands/evolve.md" << 'EOF'
---
description: Evolve the NEXUS system
allowed-tools: [Bash, Edit, Read, Write]
---

Run NEXUS evolution to upgrade the system:

!cd $NEXUS_ROOT && ./self/evolve/evolve.sh upgrade

This will:
- Apply the latest evolution patches
- Update Claude Code integration
- Enhance system capabilities
- Document changes

Review the evolution log after completion.
EOF

# Spec command
cat > "$NEXUS_ROOT/claude/commands/spec.md" << 'EOF'
---
description: Create a specification for a new feature
allowed-tools: [Edit, Write, Read]
argument-hint: <feature-description>
---

Create a detailed specification for the requested feature.

Feature: $ARGUMENTS

Based on Agent OS patterns, create:
1. Feature overview
2. User stories
3. Technical requirements
4. Implementation approach
5. Testing strategy

Follow the specification patterns from successful projects.
EOF

# Analyze command
cat > "$NEXUS_ROOT/claude/commands/analyze.md" << 'EOF'
---
description: Analyze existing codebase with NEXUS
allowed-tools: [Read, Grep, Glob]
argument-hint: <project-path>
---

Analyze the codebase to understand:

Target: $ARGUMENTS

1. Project structure and organization
2. Technology stack and dependencies
3. Code patterns and conventions
4. Architecture decisions
5. Areas for improvement

Provide a comprehensive analysis report with actionable insights.
EOF

# Create Claude Code settings templates
echo "⚙️  Creating Claude Code settings templates..."

# Base settings
cat > "$NEXUS_ROOT/claude/settings/nexus-base.json" << 'EOF'
{
  "env": {
    "NEXUS_ROOT": "${workspaceFolder}/nexus",
    "NEXUS_VERSION": "1.0.0",
    "NEXUS_AGENT_MODE": "collaborative"
  },
  "hooks": {
    "UserPromptSubmit": [{
      "matcher": "nexus|agent|evolve",
      "hooks": [{
        "type": "command",
        "command": "${NEXUS_ROOT}/claude/hooks/prompt-enhancer.sh"
      }]
    }],
    "PreToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "${NEXUS_ROOT}/claude/hooks/pre-tool-validator.sh"
      }]
    }],
    "PostToolUse": [{
      "matcher": ".*",
      "hooks": [{
        "type": "command",
        "command": "${NEXUS_ROOT}/claude/hooks/post-tool-logger.sh"
      }]
    }]
  },
  "permissions": {
    "allow": ["Bash", "Edit", "Read", "Write", "Glob", "Grep", "WebFetch"],
    "customTools": {
      "nexus": {
        "command": "${NEXUS_ROOT}/nexus",
        "description": "Run NEXUS commands",
        "allowed": true
      }
    }
  }
}
EOF

# Create hook scripts
echo "🪝 Creating hook scripts..."

# Prompt enhancer
cat > "$NEXUS_ROOT/claude/hooks/prompt-enhancer.sh" << 'EOF'
#!/bin/bash
# NEXUS Prompt Enhancer Hook

# Read the input JSON
input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // ""')

# Check if prompt mentions NEXUS concepts
if [[ "$prompt" =~ nexus|agent|evolve|forge|genesis|architect|sentinel|phoenix ]]; then
    # Add NEXUS context
    echo "🧬 NEXUS Context Enhancement Active" >&2
    
    # Get current version
    version=$(jq -r .version "$NEXUS_ROOT/self/dna/version.json" 2>/dev/null || echo "0.1.0")
    
    # Output enhanced prompt
    jq -n --arg prompt "$prompt" --arg ver "$version" '{
        prompt: ($prompt + "\n\n[NEXUS v" + $ver + " - Evolution Engine Active]"),
        metadata: {
            nexus_version: $ver,
            enhancement: "context_added"
        }
    }'
else
    # Pass through unchanged
    echo "$input"
fi
EOF
chmod +x "$NEXUS_ROOT/claude/hooks/prompt-enhancer.sh"

# Pre-tool validator
cat > "$NEXUS_ROOT/claude/hooks/pre-tool-validator.sh" << 'EOF'
#!/bin/bash
# NEXUS Pre-Tool Validator

# Read the input JSON
input=$(cat)
tool=$(echo "$input" | jq -r '.tool // ""')
path=$(echo "$input" | jq -r '.parameters.file_path // .parameters.path // ""')

# Validate NEXUS file modifications
if [[ "$path" =~ nexus/self/dna/core\.nexus ]]; then
    echo "⚠️  NEXUS DNA modification detected - validating..." >&2
    
    # Check if evolution is active
    if [ -f "$NEXUS_ROOT/.evolution-in-progress" ]; then
        echo '{"decision": "allow", "message": "Evolution in progress - modification allowed"}' 
    else
        echo '{"decision": "block", "message": "NEXUS DNA can only be modified during evolution. Run /evolve first."}' 
    fi
else
    # Allow other operations
    echo '{"decision": "allow"}'
fi
EOF
chmod +x "$NEXUS_ROOT/claude/hooks/pre-tool-validator.sh"

# Post-tool logger
cat > "$NEXUS_ROOT/claude/hooks/post-tool-logger.sh" << 'EOF'
#!/bin/bash
# NEXUS Post-Tool Logger

# Read the input JSON
input=$(cat)
tool=$(echo "$input" | jq -r '.tool // ""')
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Log tool usage for learning
log_file="$NEXUS_ROOT/self/metrics/tool-usage.jsonl"
mkdir -p "$(dirname "$log_file")"

# Append to log
echo "$input" | jq --arg time "$timestamp" --arg tool "$tool" '{
    timestamp: $time,
    tool: $tool,
    parameters: .parameters,
    result_summary: (.result | type)
}' >> "$log_file"

# Pass through
echo '{"logged": true}'
EOF
chmod +x "$NEXUS_ROOT/claude/hooks/post-tool-logger.sh"

# Create initial project templates
echo "📦 Creating project templates..."

# Web app template
cat > "$NEXUS_ROOT/factory/blueprints/web-app/template.nexus" << 'EOF'
name: Web Application
version: 1.0.0
description: Modern web application with Next.js and TypeScript
author: NEXUS Factory

structure:
  - app/
  - components/
  - lib/
  - public/
  - types/

dependencies:
  - next: latest
  - react: latest
  - typescript: latest
  - tailwindcss: latest

scripts:
  dev: next dev
  build: next build
  start: next start
  lint: next lint
  typecheck: tsc --noEmit

includes:
  - .gitignore
  - README.md
  - tsconfig.json
  - tailwind.config.js
  - package.json
EOF

# AI agent template
cat > "$NEXUS_ROOT/factory/blueprints/ai-agent/template.nexus" << 'EOF'
name: AI Agent
version: 1.0.0
description: NEXUS-compatible AI agent
author: NEXUS Factory

structure:
  - agent.yaml
  - prompts/
  - tools/
  - tests/

configuration:
  capabilities: []
  tools: []
  version: 0.1.0
EOF

# Create command primitives
echo "🔧 Creating command primitives..."

# Init command
cat > "$NEXUS_ROOT/modules/commands/primitives/init.sh" << 'EOF'
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
EOF
chmod +x "$NEXUS_ROOT/modules/commands/primitives/init.sh"

# Create Claude integration library
echo "📚 Creating Claude integration library..."
cat > "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh" << 'EOF'
#!/bin/bash
# Claude Code Integration Functions

setup_claude_commands() {
    echo "📝 Setting up Claude Code commands..."
    
    # Create user-level NEXUS commands directory
    mkdir -p "$HOME/.claude/commands/nexus"
    
    # Link or copy commands
    for cmd in "$NEXUS_ROOT/claude/commands/nexus"/*.md; do
        if [ -f "$cmd" ]; then
            local cmd_name=$(basename "$cmd")
            ln -sf "$cmd" "$HOME/.claude/commands/nexus/$cmd_name"
            echo "   ✓ Linked /nexus:${cmd_name%.md}"
        fi
    done
    
    # Link root commands
    for cmd in "$NEXUS_ROOT/claude/commands"/*.md; do
        if [ -f "$cmd" ] && [ "$(basename "$(dirname "$cmd")")" = "commands" ]; then
            local cmd_name=$(basename "$cmd")
            ln -sf "$cmd" "$HOME/.claude/commands/$cmd_name"
            echo "   ✓ Linked /${cmd_name%.md}"
        fi
    done
}

setup_claude_settings() {
    echo "⚙️  Setting up Claude Code settings..."
    
    local project_settings="$NEXUS_ROOT/.claude/settings.json"
    
    # Create .claude directory if needed
    mkdir -p "$NEXUS_ROOT/.claude"
    
    # Create or update settings
    if [ -f "$NEXUS_ROOT/claude/settings/nexus-base.json" ]; then
        cp "$NEXUS_ROOT/claude/settings/nexus-base.json" "$project_settings"
        echo "   ✓ Created project settings"
    fi
    
    # Create commands directory in project
    mkdir -p "$NEXUS_ROOT/.claude/commands"
    echo "   ✓ Created project commands directory"
}
EOF
chmod +x "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh"

echo ""
echo "✅ Evolution 1.0: Synthesis - Structure created successfully!"
echo ""
echo "📋 Created:"
echo "   • Claude Code slash commands for all agents"
echo "   • Hook scripts for enhanced functionality"
echo "   • Project templates in factory/blueprints"
echo "   • Command primitives"
echo "   • Integration library"
echo ""
echo "🔗 Next: Setting up Claude Code integration..."

# Now set up the actual integration
if [ -f "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh" ]; then
    source "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh"
    setup_claude_commands
    setup_claude_settings
fi

echo ""
echo "🎉 Evolution 1.0: Synthesis complete!"
echo ""
echo "📚 What's new:"
echo "   • Use /nexus:genesis to create new projects"
echo "   • Use /nexus:architect to design systems"
echo "   • Use /nexus:forge to generate code"
echo "   • Use /evolve to upgrade NEXUS"
echo "   • Hooks enhance your prompts automatically"
echo ""
echo "🚀 Your NEXUS has evolved!"

exit 0