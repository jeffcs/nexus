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
