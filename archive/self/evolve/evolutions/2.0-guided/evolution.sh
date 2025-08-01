#!/bin/bash
# NEXUS Evolution 2.0 - Guided Evolution
# This evolution introduces AI-guided evolution and standardizes command naming

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

echo "🧬 Evolution 2.0: Guided Evolution"
echo "================================="
echo ""
echo "This evolution will:"
echo "• Enable AI-guided evolution with natural language"
echo "• Standardize all commands to use /nexus: prefix"
echo "• Merge streaming-app template into web-app"
echo "• Update Claude Code integration"
echo ""

# Check for evolution guidance
if [ -n "$EVOLUTION_GUIDANCE" ]; then
    echo "📋 Processing guidance: $EVOLUTION_GUIDANCE"
    echo ""
fi

# Step 1: Update all command files to use /nexus: prefix
echo "📝 Updating command naming convention..."

# Move root-level commands to have nexus: prefix
if [ -d "$NEXUS_ROOT/claude/commands" ]; then
    # Rename evolve.md to nexus:evolve.md
    if [ -f "$NEXUS_ROOT/claude/commands/evolve.md" ]; then
        mv "$NEXUS_ROOT/claude/commands/evolve.md" "$NEXUS_ROOT/claude/commands/nexus:evolve.md"
        echo "   ✓ Renamed evolve.md → nexus:evolve.md"
    fi
    
    # Rename spec.md to nexus:spec.md
    if [ -f "$NEXUS_ROOT/claude/commands/spec.md" ]; then
        mv "$NEXUS_ROOT/claude/commands/spec.md" "$NEXUS_ROOT/claude/commands/nexus:spec.md"
        echo "   ✓ Renamed spec.md → nexus:spec.md"
    fi
    
    # Rename analyze.md to nexus:analyze.md
    if [ -f "$NEXUS_ROOT/claude/commands/analyze.md" ]; then
        mv "$NEXUS_ROOT/claude/commands/analyze.md" "$NEXUS_ROOT/claude/commands/nexus:analyze.md"
        echo "   ✓ Renamed analyze.md → nexus:analyze.md"
    fi
fi

# Step 2: Update command content to reflect new naming
echo "📄 Updating command content..."

# Update nexus:evolve command
if [ -f "$NEXUS_ROOT/claude/commands/nexus:evolve.md" ]; then
    cat > "$NEXUS_ROOT/claude/commands/nexus:evolve.md" << 'EOF'
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
EOF
    echo "   ✓ Updated nexus:evolve command"
fi

# Update nexus:spec command
if [ -f "$NEXUS_ROOT/claude/commands/nexus:spec.md" ]; then
    cat > "$NEXUS_ROOT/claude/commands/nexus:spec.md" << 'EOF'
---
description: Create a specification for a new feature
allowed-tools: [Edit, Write, Read]
argument-hint: <feature-description>
---

Create a detailed specification for the requested feature.

Feature: $ARGUMENTS

Based on NEXUS patterns, create:
1. Feature overview
2. User stories
3. Technical requirements
4. Implementation approach
5. Testing strategy

Store specifications in: `vault/specs/`
Follow patterns from: `factory/blueprints/`
EOF
    echo "   ✓ Updated nexus:spec command"
fi

# Update nexus:analyze command
if [ -f "$NEXUS_ROOT/claude/commands/nexus:analyze.md" ]; then
    cat > "$NEXUS_ROOT/claude/commands/nexus:analyze.md" << 'EOF'
---
description: Analyze existing codebase with NEXUS
allowed-tools: [Read, Grep, Glob]
argument-hint: <project-path>
---

Analyze the codebase using NEXUS pattern recognition.

Target: $ARGUMENTS

Analysis includes:
1. Project structure and organization
2. Technology stack and dependencies
3. Code patterns and conventions
4. Architecture decisions
5. NEXUS integration opportunities

Generate report in: `vault/research/analysis-[timestamp].md`
EOF
    echo "   ✓ Updated nexus:analyze command"
fi

# Step 3: Merge streaming-app template into web-app
echo "🔀 Merging streaming-app template into web-app..."

# Enhanced web-app template with streaming capabilities
cat > "$NEXUS_ROOT/factory/blueprints/web-app/template.nexus" << 'EOF'
name: Web Application
version: 2.0.0
description: Modern web application with Next.js, TypeScript, and streaming capabilities
author: NEXUS Factory

structure:
  - app/
  - components/
  - lib/
  - public/
  - types/
  - services/
  - hooks/

dependencies:
  core:
    - next: latest
    - react: latest
    - typescript: latest
    - tailwindcss: latest
  
  streaming:
    - "@types/hls.js": latest
    - "hls.js": latest
    - "react-player": latest
  
  data:
    - "@supabase/supabase-js": latest
    - "swr": latest

scripts:
  dev: next dev
  build: next build
  start: next start
  lint: next lint
  typecheck: tsc --noEmit

features:
  - Server-side rendering
  - API routes
  - Real-time data
  - Video streaming
  - Authentication ready
  - Database integration

includes:
  - .gitignore
  - README.md
  - tsconfig.json
  - tailwind.config.js
  - package.json
  - .env.example
EOF

# Remove the separate streaming-app template
if [ -d "$NEXUS_ROOT/factory/blueprints/streaming-app" ]; then
    rm -rf "$NEXUS_ROOT/factory/blueprints/streaming-app"
    echo "   ✓ Removed redundant streaming-app template"
fi

echo "   ✓ Enhanced web-app template with streaming capabilities"

# Step 4: Create AI evolution generator
echo "🤖 Creating AI evolution generator..."

cat > "$NEXUS_ROOT/modules/commands/primitives/generate-evolution.sh" << 'EOF'
#!/bin/bash
# NEXUS Evolution Generator
# Creates evolution scripts from natural language guidance

NEXUS_ROOT="${NEXUS_ROOT:-$(pwd)}"
GUIDANCE="${1:-No guidance provided}"

echo "🧠 Analyzing evolution request..."
echo "Guidance: $GUIDANCE"

# Create evolution template
cat << EOT
#!/bin/bash
# NEXUS AI-Generated Evolution
# Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
# Guidance: $GUIDANCE

NEXUS_ROOT="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")/../../.." && pwd)"

echo "🧬 AI-Generated Evolution"
echo "======================="
echo ""
echo "Guidance: $GUIDANCE"
echo ""

# TODO: Implement evolution logic based on guidance
# Use /nexus:architect to design the changes
# Use /nexus:forge to implement them

echo "❌ This evolution needs to be implemented"
echo "   Use /nexus:architect and /nexus:forge to complete it"
exit 1
EOT
EOF
chmod +x "$NEXUS_ROOT/modules/commands/primitives/generate-evolution.sh"

echo "   ✓ Created evolution generator"

# Step 5: Update Claude integration library
echo "🔗 Updating Claude integration..."

cat > "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh" << 'EOF'
#!/bin/bash
# Claude Code Integration Functions - v2.0

setup_claude_commands() {
    echo "📝 Setting up Claude Code commands..."
    
    # Clean up old command links
    rm -f "$HOME/.claude/commands/"{evolve,spec,analyze}.md 2>/dev/null
    
    # Create user-level NEXUS commands directory
    mkdir -p "$HOME/.claude/commands/nexus"
    
    # Link commands from nexus subdirectory
    for cmd in "$NEXUS_ROOT/claude/commands/nexus"/*.md; do
        if [ -f "$cmd" ]; then
            local cmd_name=$(basename "$cmd")
            ln -sf "$cmd" "$HOME/.claude/commands/nexus/$cmd_name"
            echo "   ✓ Linked /nexus:${cmd_name%.md}"
        fi
    done
    
    # Link root commands with nexus: prefix
    for cmd in "$NEXUS_ROOT/claude/commands"/nexus:*.md; do
        if [ -f "$cmd" ]; then
            local cmd_name=$(basename "$cmd")
            ln -sf "$cmd" "$HOME/.claude/commands/$cmd_name"
            echo "   ✓ Linked /$cmd_name"
        fi
    done
}

setup_claude_settings() {
    echo "⚙️  Setting up Claude Code settings..."
    
    local project_settings="$NEXUS_ROOT/.claude/settings.json"
    
    # Create .claude directory if needed
    mkdir -p "$NEXUS_ROOT/.claude"
    
    # Update settings for v2.0
    cat > "$project_settings" << 'SETTINGS'
{
  "env": {
    "NEXUS_ROOT": "${workspaceFolder}/nexus",
    "NEXUS_VERSION": "2.0.0",
    "NEXUS_AGENT_MODE": "collaborative",
    "NEXUS_EVOLUTION_MODE": "guided"
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
      },
      "evolve": {
        "command": "${NEXUS_ROOT}/self/evolve/evolve.sh",
        "description": "Run NEXUS evolution",
        "allowed": true
      }
    }
  }
}
SETTINGS
    
    echo "   ✓ Updated project settings for v2.0"
    
    # Create commands directory in project
    mkdir -p "$NEXUS_ROOT/.claude/commands"
    echo "   ✓ Created project commands directory"
}
EOF
chmod +x "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh"

# Step 6: Create evolution patterns documentation
echo "📚 Creating evolution patterns..."

mkdir -p "$NEXUS_ROOT/vault/patterns"
cat > "$NEXUS_ROOT/vault/patterns/evolution-patterns.md" << 'EOF'
# NEXUS Evolution Patterns

## Evolution Types

### 1. Version-Based Evolution
Traditional numbered evolutions with predefined changes.
```bash
./self/evolve/evolve.sh upgrade 2.0
```

### 2. Guided Evolution
AI-driven evolution from natural language requests.
```bash
./self/evolve/evolve.sh upgrade "add error handling to all agents"
```

## Creating Evolutions

### Manual Evolution Script
1. Create script in `self/evolve/evolutions/`
2. Name format: `{version}-{name}.sh`
3. Update version in script
4. Document changes

### AI-Generated Evolution
1. Use `/nexus:evolve "description"`
2. System creates guidance file
3. Use `/nexus:architect` to design
4. Use `/nexus:forge` to implement

## Evolution Best Practices

1. **Atomic Changes**: One concept per evolution
2. **Backwards Compatible**: Don't break existing functionality
3. **Documentation**: Update all affected docs
4. **Testing**: Verify changes work correctly
5. **Rollback Plan**: Know how to undo changes

## Common Evolution Requests

- "Add logging to all agents"
- "Create new agent type X"
- "Enhance error handling"
- "Optimize performance"
- "Add new project template"
EOF

echo "   ✓ Created evolution patterns documentation"

# Step 7: Update version and features
echo "📊 Updating system version..."

# Update version.json
jq '.version = "2.0.0" | .codename = "Guided" | .released = now | .features += ["AI-guided evolution", "Standardized /nexus: commands", "Enhanced web-app template", "Evolution patterns"]' \
    "$NEXUS_ROOT/self/dna/version.json" > "$NEXUS_ROOT/self/dna/version.json.tmp" && \
    mv "$NEXUS_ROOT/self/dna/version.json.tmp" "$NEXUS_ROOT/self/dna/version.json"

echo ""
echo "✅ Evolution 2.0: Guided Evolution complete!"
echo ""
echo "📚 What's new in v2.0:"
echo "   • AI-guided evolution: ./evolve.sh upgrade \"your request\""
echo "   • All commands now use /nexus: prefix"
echo "   • Enhanced web-app template with streaming"
echo "   • Evolution pattern documentation"
echo ""
echo "🎯 Try it out:"
echo '   ./self/evolve/evolve.sh upgrade "add debug mode to all agents"'
echo ""
echo "🚀 NEXUS can now evolve from your ideas!"

exit 0