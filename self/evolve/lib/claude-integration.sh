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
