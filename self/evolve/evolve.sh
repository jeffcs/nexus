#!/bin/bash
# NEXUS Evolution Engine - Enhanced with Claude Code Integration

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NEXUS_VERSION="1.0.0"

# Source common functions if available
source "$NEXUS_ROOT/self/evolve/lib/common.sh" 2>/dev/null || true

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_header() {
    echo "╔══════════════════════════════════════════╗"
    echo "║          NEXUS EVOLUTION ENGINE          ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
}

show_status() {
    echo "📊 System Status:"
    echo "   Version: $(jq -r .version "$NEXUS_ROOT/self/dna/version.json" 2>/dev/null || echo '0.1.0')"
    echo "   Agents: $(find "$NEXUS_ROOT/modules/agents" -maxdepth 1 -type d | tail -n +2 | wc -l)"
    echo "   Commands: $(find "$NEXUS_ROOT/modules/commands" -name "*.sh" 2>/dev/null | wc -l)"
    echo "   Experiments: $(find "$NEXUS_ROOT/lab/experiments" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)"
    
    # Check Claude Code integration
    if [ -d "$HOME/.claude/commands" ] || [ -d ".claude/commands" ]; then
        echo "   Claude Code: ✅ Integrated"
        local cmd_count=$(find "$HOME/.claude/commands" -name "*.md" 2>/dev/null | grep -c "nexus" || echo "0")
        echo "   NEXUS Commands: $cmd_count registered"
    else
        echo "   Claude Code: ❌ Not integrated"
    fi
}

run_evolution() {
    local evolution_version="${1:-1.0}"
    local evolution_script="$NEXUS_ROOT/self/evolve/evolutions/${evolution_version}-synthesis.sh"
    
    echo "🧬 Initiating system evolution to v${evolution_version}..."
    echo ""
    
    # Check if evolution script exists
    if [ ! -f "$evolution_script" ]; then
        echo "⚠️  Evolution script not found. Creating it now..."
        create_evolution_script "$evolution_version"
    fi
    
    # Check current version
    local current_version=$(jq -r .version "$NEXUS_ROOT/self/dna/version.json" 2>/dev/null || echo "0.1.0")
    echo "📍 Current version: $current_version"
    echo "🎯 Target version: $evolution_version"
    echo ""
    
    # Run pre-evolution checks
    echo "🔍 Running pre-evolution checks..."
    if ! pre_evolution_checks; then
        echo "❌ Pre-evolution checks failed. Please resolve issues and try again."
        return 1
    fi
    
    # Execute evolution
    echo "🚀 Applying evolution..."
    if bash "$evolution_script"; then
        echo "✅ Evolution complete!"
        
        # Update version
        update_version "$evolution_version"
        
        # Run post-evolution tasks
        post_evolution_tasks
    else
        echo "❌ Evolution failed. Check the logs for details."
        return 1
    fi
}

pre_evolution_checks() {
    # Check git status
    if [ -d ".git" ]; then
        if ! git diff --quiet; then
            echo "⚠️  Warning: You have uncommitted changes"
            echo "   Consider committing before evolution"
            read -p "   Continue anyway? (y/N) " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Yy]$ ]] && return 1
        fi
    fi
    
    # Check write permissions
    if [ ! -w "$NEXUS_ROOT" ]; then
        echo "❌ No write permission in NEXUS directory"
        return 1
    fi
    
    return 0
}

post_evolution_tasks() {
    echo ""
    echo "🔧 Running post-evolution tasks..."
    
    # Update evolution log
    local evolution_log="$NEXUS_ROOT/self/dna/evolution-log.json"
    if [ ! -f "$evolution_log" ]; then
        echo '{"evolutions": []}' > "$evolution_log"
    fi
    
    # Add evolution entry
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq --arg ver "$NEXUS_VERSION" --arg time "$timestamp" \
        '.evolutions += [{"version": $ver, "timestamp": $time, "status": "success"}]' \
        "$evolution_log" > "$evolution_log.tmp" && mv "$evolution_log.tmp" "$evolution_log"
    
    # Check Claude Code integration
    if command -v claude &> /dev/null; then
        echo "🔗 Updating Claude Code integration..."
        integrate_claude_code
    fi
}

integrate_claude_code() {
    # Source Claude integration functions
    source "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh" 2>/dev/null || {
        echo "⚠️  Claude integration library not found. Creating..."
        create_claude_integration_lib
        source "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh"
    }
    
    # Run integration
    setup_claude_commands
    setup_claude_settings
    echo "✅ Claude Code integration updated"
}

create_evolution_script() {
    local version="$1"
    local script_path="$NEXUS_ROOT/self/evolve/evolutions/${version}-synthesis.sh"
    
    mkdir -p "$(dirname "$script_path")"
    
    cat > "$script_path" << 'EOF'
#!/bin/bash
# NEXUS Evolution 1.0 - Synthesis
# This evolution integrates Claude Code and establishes core patterns

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

echo "🧬 Evolution 1.0: Synthesis"
echo "=========================="
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

# Create command primitives
echo "⚡ Creating command primitives..."
mkdir -p "$NEXUS_ROOT/modules/commands/primitives"

echo ""
echo "✅ Evolution 1.0 structure created"
echo ""
echo "Next steps:"
echo "1. Run 'nexus' to see available commands"
echo "2. Use '/nexus:genesis' in Claude Code to create projects"
echo "3. Check 'nexus status' to see system state"

exit 0
EOF
    
    chmod +x "$script_path"
    echo "✅ Created evolution script: $script_path"
}

update_version() {
    local new_version="$1"
    local version_file="$NEXUS_ROOT/self/dna/version.json"
    
    # Update version.json
    jq --arg ver "$new_version" \
        '.version = $ver | .codename = "Synthesis" | .released = now | .features += ["Claude Code integration", "Evolution system", "Project templates", "Agent slash commands"]' \
        "$version_file" > "$version_file.tmp" && mv "$version_file.tmp" "$version_file"
}

create_agent() {
    local agent_name="${1:-unnamed}"
    echo "🤖 Creating new agent: $agent_name"
    
    # Create agent directory
    mkdir -p "$NEXUS_ROOT/modules/agents/$agent_name"
    
    # Create agent configuration
    cat > "$NEXUS_ROOT/modules/agents/$agent_name/agent.yaml" << EOF
name: $agent_name
version: 0.1.0
role: Custom Agent
author: NEXUS User

capabilities:
  - custom_capability

prompts:
  primary: |
    You are $agent_name, a NEXUS agent.
    Your role is to be defined by the user.
    
    Core principles:
    - Follow NEXUS philosophy
    - Collaborate with other agents
    - Learn and evolve

tools:
  - file_operations
  - command_execution
EOF

    # Create Claude command for the agent
    if [ -d "$NEXUS_ROOT/claude/commands/nexus" ]; then
        cat > "$NEXUS_ROOT/claude/commands/nexus/$agent_name.md" << EOF
---
description: Run the $agent_name agent
allowed-tools: [Bash, Edit, Read]
argument-hint: <task>
---

You are $agent_name, a NEXUS agent.

Task: \$ARGUMENTS

@$NEXUS_ROOT/modules/agents/$agent_name/agent.yaml

Execute the requested task following your defined role and capabilities.
EOF
    fi
    
    echo "✅ Agent scaffold created"
    echo "📝 Edit modules/agents/$agent_name/agent.yaml to define the agent's role"
}

create_claude_integration_lib() {
    mkdir -p "$NEXUS_ROOT/self/evolve/lib"
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
        fi
    done
    
    # Link root commands
    for cmd in "$NEXUS_ROOT/claude/commands"/*.md; do
        if [ -f "$cmd" ] && [ "$(basename "$(dirname "$cmd")")" = "commands" ]; then
            local cmd_name=$(basename "$cmd")
            ln -sf "$cmd" "$HOME/.claude/commands/$cmd_name"
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
    fi
}
EOF
    chmod +x "$NEXUS_ROOT/self/evolve/lib/claude-integration.sh"
}

# Main execution
show_header

case "${1:-status}" in
    status)
        show_status
        ;;
    
    upgrade)
        run_evolution "${2:-1.0}"
        ;;
    
    agent)
        create_agent "$2"
        ;;
    
    rollback)
        echo "🔄 Rollback functionality coming soon..."
        ;;
    
    help|--help|-h)
        echo "Usage: ./evolve.sh [command] [options]"
        echo ""
        echo "Commands:"
        echo "  status              Show system status"
        echo "  upgrade [version]   Upgrade to specified version (default: 1.0)"
        echo "  agent <name>        Create a new agent"
        echo "  rollback [version]  Rollback to previous version"
        echo "  help               Show this help message"
        echo ""
        echo "Examples:"
        echo "  ./evolve.sh status"
        echo "  ./evolve.sh upgrade 1.0"
        echo "  ./evolve.sh agent analyst"
        ;;
    
    *)
        echo "Unknown command: $1"
        echo "Usage: ./evolve.sh [status|upgrade|agent|rollback|help]"
        exit 1
        ;;
esac