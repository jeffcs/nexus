#!/bin/bash
# NEXUS Evolution Engine - Enhanced with Claude Code Integration

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# Get current version dynamically
NEXUS_VERSION=$(jq -r '.version // "4.0.0"' "$NEXUS_ROOT/self/dna/version.json" 2>/dev/null || echo "4.0.0")

# Source common functions if available
source "$NEXUS_ROOT/self/evolve/lib/common.sh" 2>/dev/null || true
source "$NEXUS_ROOT/self/evolve/lib/learning-system.sh" 2>/dev/null || true
source "$NEXUS_ROOT/self/evolve/lib/evolution-generator.sh" 2>/dev/null || true

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
        local cmd_count=$(find "$NEXUS_ROOT/claude/commands/nexus" -name "*.md" 2>/dev/null | wc -l | tr -d ' ' || echo "0")
        echo "   NEXUS Commands: $cmd_count registered"
    else
        echo "   Claude Code: ❌ Not integrated"
    fi
}

run_evolution() {
    local evolution_version="${1:-}"
    local evolution_guidance="${2:-}"
    
    # If no version specified, calculate next major version
    if [ -z "$evolution_version" ]; then
        local current_version=$(jq -r '.version // "4.0.0"' "$NEXUS_ROOT/self/dna/version.json" 2>/dev/null || echo "4.0.0")
        local major_version=$(echo "$current_version" | cut -d. -f1)
        evolution_version="$((major_version + 1)).0.0"
    fi
    
    # Capture learnings and validate proposals before evolution
    if type capture_learnings &>/dev/null; then
        capture_learnings "$evolution_guidance"
        # Update guidance with final validated version
        if [ -f "$NEXUS_ROOT/self/learnings/evolution-guidance-final.md" ]; then
            evolution_guidance=$(cat "$NEXUS_ROOT/self/learnings/evolution-guidance-final.md")
        fi
    fi
    
    # Determine evolution script name based on version
    local script_name
    case "$evolution_version" in
        1.0) script_name="1.0-synthesis" ;;
        2.0) script_name="2.0-guided" ;;
        3.0) script_name="3.0-evolution" ;;
        4.0) script_name="4.0-core-implementation" ;;
        *) script_name="${evolution_version}-evolution" ;;
    esac
    
    # Check for new directory structure first
    local evolution_script="$NEXUS_ROOT/self/evolve/evolutions/${script_name}/evolution.sh"
    if [ ! -f "$evolution_script" ]; then
        # Fall back to old structure
        evolution_script="$NEXUS_ROOT/self/evolve/evolutions/${script_name}.sh"
    fi
    
    echo "🧬 Initiating system evolution to v${evolution_version}..."
    if [ -n "$evolution_guidance" ]; then
        echo "🎯 Guided evolution: $evolution_guidance"
    fi
    echo ""
    
    # Check if evolution script exists
    if [ ! -f "$evolution_script" ]; then
        echo "⚠️  Evolution script not found. Generating intelligent evolution..."
        
        # Use evolution generator
        if type generate_next_evolution &>/dev/null; then
            local evolution_dir=$(generate_next_evolution "$current_version")
            evolution_script="$evolution_dir/evolution.sh"
            echo "✅ Generated evolution plan: $evolution_dir/plan.md"
            echo "📝 Review the plan before proceeding!"
            echo ""
            cat "$evolution_dir/plan.md"
            echo ""
            read -p "Proceed with this evolution? (y/N) " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Yy]$ ]] && return 1
        else
            # Fallback to old method
            if [ "$evolution_version" = "2.0" ]; then
                create_evolution_2_0_script "$evolution_guidance"
            else
                create_evolution_script "$evolution_version"
            fi
        fi
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
    # Pass guidance as environment variable
    EVOLUTION_GUIDANCE="$evolution_guidance" bash "$evolution_script"
    if [ $? -eq 0 ]; then
        echo "✅ Evolution complete!"
        
        # Update version
        update_version "$evolution_version"
        
        # Run post-evolution tasks
        post_evolution_tasks "$evolution_version"
    else
        echo "❌ Evolution failed. Check the logs for details."
        return 1
    fi
}

evolve_with_guidance() {
    # New function for guided evolution
    local guidance="$1"
    
    # Capture learnings and validate proposals before evolution
    if type capture_learnings &>/dev/null; then
        capture_learnings "$guidance"
        # Update guidance with final validated version
        if [ -f "$NEXUS_ROOT/self/learnings/evolution-guidance-final.md" ]; then
            guidance=$(cat "$NEXUS_ROOT/self/learnings/evolution-guidance-final.md")
        fi
    fi
    
    echo "🤖 AI-Guided Evolution Request"
    echo "================================"
    echo ""
    echo "📋 Guidance: $guidance"
    echo ""
    
    # Create evolution marker
    touch "$NEXUS_ROOT/.evolution-in-progress"
    
    # Generate evolution script based on guidance
    local evolution_name="custom-$(date +%s)"
    local evolution_script="$NEXUS_ROOT/self/evolve/evolutions/${evolution_name}.sh"
    
    echo "🧠 Analyzing evolution request..."
    echo "📝 Generating evolution script: $evolution_name"
    
    # Create a temporary guidance file for the AI
    local guidance_file="$NEXUS_ROOT/lab/experiments/evolution-guidance.md"
    mkdir -p "$(dirname "$guidance_file")"
    
    cat > "$guidance_file" << EOF
# Evolution Guidance

User Request: $guidance

Please analyze this request and create an evolution script that:
1. Implements the requested changes
2. Updates any affected commands or configurations
3. Maintains system consistency
4. Documents the changes

Current NEXUS version: $(jq -r .version "$NEXUS_ROOT/self/dna/version.json" 2>/dev/null || echo "1.0")
EOF
    
    echo ""
    echo "🔮 Use /nexus:architect to design the evolution"
    echo "🛠️  Use /nexus:forge to implement the changes"
    echo ""
    echo "📍 Guidance saved to: $guidance_file"
    echo "📍 Evolution script will be: $evolution_script"
    
    # Clean up marker
    rm -f "$NEXUS_ROOT/.evolution-in-progress"
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
    local version="${1:-2.0}"
    echo ""
    echo "🔧 Running post-evolution tasks..."
    
    # Update evolution log
    local evolution_log="$NEXUS_ROOT/self/dna/evolution-log.json"
    if [ ! -f "$evolution_log" ]; then
        echo '{"evolutions": []}' > "$evolution_log"
    fi
    
    # Add evolution entry
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq --arg ver "$version" --arg time "$timestamp" \
        '.evolutions += [{"version": $ver, "timestamp": $time, "status": "success"}]' \
        "$evolution_log" > "$evolution_log.tmp" && mv "$evolution_log.tmp" "$evolution_log"
    
    # Archive learnings in evolution directory
    local evolution_dir="$NEXUS_ROOT/self/evolve/evolutions/${version}-evolution"
    if [ ! -d "$evolution_dir" ]; then
        # Try alternate naming schemes
        evolution_dir="$NEXUS_ROOT/self/evolve/evolutions/${version}"
        if [ ! -d "$evolution_dir" ]; then
            case "$version" in
                1.0) evolution_dir="$NEXUS_ROOT/self/evolve/evolutions/1.0-synthesis" ;;
                2.0) evolution_dir="$NEXUS_ROOT/self/evolve/evolutions/2.0-guided" ;;
                3.0) evolution_dir="$NEXUS_ROOT/self/evolve/evolutions/3.0-evolution" ;;
                4.0) evolution_dir="$NEXUS_ROOT/self/evolve/evolutions/4.0-core-implementation" ;;
                *) evolution_dir="$NEXUS_ROOT/self/evolve/evolutions/${version}-evolution" ;;
            esac
        fi
    fi
    
    # Save any temporary learnings to evolution directory
    if [ -d "$NEXUS_ROOT/self/learnings" ] && [ -n "$(ls -A "$NEXUS_ROOT/self/learnings" 2>/dev/null)" ]; then
        echo "📚 Archiving evolution learnings..."
        mkdir -p "$evolution_dir"
        find "$NEXUS_ROOT/self/learnings" -maxdepth 1 -name "*.md" -exec mv {} "$evolution_dir/" \;
    fi
    
    # Create git tag if in git repo
    if [ -d ".git" ] && command -v git &> /dev/null; then
        echo "🏷️  Creating git tag v${version}..."
        git tag -a "v${version}" -m "NEXUS Evolution v${version} - $(date)" 2>/dev/null || echo "   Tag already exists"
    fi
    
    # Check Claude Code integration
    if command -v claude &> /dev/null || [ -d "$HOME/.claude" ]; then
        echo "🔗 Updating Claude Code integration..."
        integrate_claude_code
    fi
    
    # Generate evolution summary
    echo ""
    echo "📋 Evolution Summary"
    echo "==================="
    echo "Version: ${version}"
    echo "Date: $(date)"
    if [ -f "$NEXUS_ROOT/self/learnings/archive/v${version}/evolution-${version}-complete.md" ]; then
        echo "Learnings: Archived to self/learnings/archive/v${version}/"
    fi
    echo ""
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

create_evolution_2_0_script() {
    local guidance="${1:-}"
    local script_path="$NEXUS_ROOT/self/evolve/evolutions/2.0-guided.sh"
    
    mkdir -p "$(dirname "$script_path")"
    
    # This will be created by the actual evolution implementation
    echo "#!/bin/bash" > "$script_path"
    echo "# NEXUS Evolution 2.0 - Guided Evolution" >> "$script_path"
    echo "# This is a placeholder - run the evolution to generate the actual script" >> "$script_path"
    echo "echo 'Evolution 2.0 script needs to be implemented'" >> "$script_path"
    echo "exit 1" >> "$script_path"
    
    chmod +x "$script_path"
}

create_evolution_script() {
    local version="$1"
    local script_path="$NEXUS_ROOT/self/evolve/evolutions/${version}-evolution.sh"
    
    mkdir -p "$(dirname "$script_path")"
    
    cat > "$script_path" << 'EOF'
#!/bin/bash
# NEXUS Evolution Script
echo "Generic evolution script for version $version"
echo "Please implement specific evolution logic"
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
        '.version = $ver | .released = now' \
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
            echo "   ✓ Linked /nexus:${cmd_name%.md}"
        fi
    done
    
    # Link root commands - now with nexus: prefix
    for cmd in "$NEXUS_ROOT/claude/commands"/*.md; do
        if [ -f "$cmd" ] && [ "$(basename "$(dirname "$cmd")")" = "commands" ]; then
            local cmd_name=$(basename "$cmd" .md)
            # Create nexus: prefixed version
            ln -sf "$cmd" "$HOME/.claude/commands/nexus:$cmd_name.md"
            echo "   ✓ Linked /nexus:$cmd_name"
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
}

# Main execution
show_header

case "${1:-status}" in
    status)
        show_status
        ;;
    
    upgrade)
        if [ -n "$2" ] && [[ ! "$2" =~ ^[0-9]+\.[0-9]+$ ]]; then
            # If second argument is not a version number, treat as guidance
            evolve_with_guidance "$2"
        else
            # Traditional version-based evolution
            run_evolution "${2:-2.0}" "${3:-}"
        fi
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
        echo "  upgrade             Evolve to next version (auto-increments)"
        echo "  upgrade [version]   Evolve to specific version"
        echo "  upgrade \"guidance\"  AI-guided evolution with natural language"
        echo "  agent <name>        Create a new agent"
        echo "  rollback [version]  Rollback to previous version"
        echo "  help               Show this help message"
        echo ""
        echo "Examples:"
        echo "  ./evolve.sh status"
        echo "  ./evolve.sh upgrade           # Evolves to next major version"
        echo "  ./evolve.sh upgrade 6.0.0     # Evolves to specific version"
        echo "  ./evolve.sh upgrade \"add logging to all agents\""
        echo "  ./evolve.sh agent analyst"
        ;;
    
    *)
        echo "Unknown command: $1"
        echo "Usage: ./evolve.sh [status|upgrade|agent|rollback|help]"
        exit 1
        ;;
esac