#!/bin/bash
# NEXUS Agent Runtime Engine

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Load agent configuration
load_agent() {
    local agent_name="$1"
    local agent_config="$NEXUS_ROOT/modules/agents/$agent_name/agent.yaml"
    
    if [ ! -f "$agent_config" ]; then
        echo "❌ Agent not found: $agent_name"
        return 1
    fi
    
    # Parse YAML (simple extraction)
    local role=$(grep "^role:" "$agent_config" | cut -d: -f2- | xargs)
    local version=$(grep "^version:" "$agent_config" | cut -d: -f2 | xargs)
    
    echo "🤖 Loading $agent_name v$version"
    echo "   Role: $role"
    
    # Load structured prompt if exists
    local structured_prompt=$(grep "^structured_prompt:" "$agent_config" | cut -d: -f2 | xargs | tr -d '"@')
    if [ -n "$structured_prompt" ]; then
        local prompt_file="$NEXUS_ROOT/$structured_prompt"
        if [ -f "$prompt_file" ]; then
            echo "   ✓ Structured guidance loaded"
        fi
    fi
    
    return 0
}

# Execute agent task
execute_agent() {
    local agent_name="$1"
    local task="$2"
    
    if ! load_agent "$agent_name"; then
        return 1
    fi
    
    echo ""
    echo "🎯 Executing task: $task"
    echo ""
    
    # Create execution context
    local context_file="$NEXUS_ROOT/core/runtime/contexts/$(date +%s)-$agent_name.json"
    mkdir -p "$(dirname "$context_file")"
    
    cat > "$context_file" << CONTEXT
{
    "agent": "$agent_name",
    "task": "$task",
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "status": "executing"
}
CONTEXT
    
    echo "📁 Context: $context_file"
    echo ""
    echo "💡 Use the agent's capabilities to complete the task"
    
    return 0
}

# Main execution
case "${1:-help}" in
    run)
        execute_agent "$2" "$3"
        ;;
    load)
        load_agent "$2"
        ;;
    list)
        echo "Available agents:"
        for agent in "$NEXUS_ROOT/modules/agents"/*/agent.yaml; do
            if [ -f "$agent" ]; then
                agent_name=$(basename "$(dirname "$agent")")
                echo "  - $agent_name"
            fi
        done
        ;;
    *)
        echo "Usage: agent-runtime.sh [run|load|list] <agent> [task]"
        ;;
esac
