#!/bin/bash
# NEXUS Orchestrator - Multi-agent coordination

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Analyze task and assign to agents
analyze_task() {
    local task="$1"
    echo "🔍 Analyzing task: $task"
    echo ""
    
    # Simple keyword-based agent selection
    local agents=()
    
    if [[ "$task" =~ design|architect|system|structure ]]; then
        agents+=("architect")
    fi
    
    if [[ "$task" =~ code|implement|build|create ]]; then
        agents+=("forge")
    fi
    
    if [[ "$task" =~ test|quality|review|check ]]; then
        agents+=("sentinel")
    fi
    
    if [[ "$task" =~ fix|repair|recover|debug ]]; then
        agents+=("phoenix")
    fi
    
    if [[ "$task" =~ new|project|bootstrap|init ]]; then
        agents+=("genesis")
    fi
    
    if [ ${#agents[@]} -eq 0 ]; then
        # Default to architect for planning
        agents+=("architect")
    fi
    
    echo "📋 Recommended agents: ${agents[*]}"
    echo ""
    
    # Create workflow
    local workflow_id="workflow-$(date +%s)"
    local workflow_file="$NEXUS_ROOT/core/orchestrator/workflows/$workflow_id.json"
    mkdir -p "$(dirname "$workflow_file")"
    
    # Build agent array for JSON
    local agent_json=$(printf '%s\n' "${agents[@]}" | jq -R . | jq -s .)
    
    jq -n --arg id "$workflow_id" --arg task "$task" --argjson agents "$agent_json" \
        '{id: $id, task: $task, agents: $agents, status: "planned", created: now}' \
        > "$workflow_file"
    
    echo "🔗 Workflow created: $workflow_id"
    echo ""
    
    # Show execution plan
    echo "📝 Execution plan:"
    local step=1
    for agent in "${agents[@]}"; do
        echo "   $step. $agent: Analyze and execute relevant parts"
        ((step++))
    done
    
    echo ""
    echo "▶️  To execute: orchestrator.sh execute $workflow_id"
}

# Execute workflow
execute_workflow() {
    local workflow_id="$1"
    local workflow_file="$NEXUS_ROOT/core/orchestrator/workflows/$workflow_id.json"
    
    if [ ! -f "$workflow_file" ]; then
        echo "❌ Workflow not found: $workflow_id"
        return 1
    fi
    
    echo "🚀 Executing workflow: $workflow_id"
    echo ""
    
    # Get task and agents
    local task=$(jq -r '.task' "$workflow_file")
    local agents=$(jq -r '.agents[]' "$workflow_file")
    
    echo "📋 Task: $task"
    echo ""
    
    # Execute each agent
    while IFS= read -r agent; do
        echo "➤ Running $agent agent..."
        "$NEXUS_ROOT/core/runtime/agent-runtime.sh" run "$agent" "$task"
        echo ""
    done <<< "$agents"
    
    # Update workflow status
    jq '.status = "completed" | .completed = now' "$workflow_file" > "$workflow_file.tmp"
    mv "$workflow_file.tmp" "$workflow_file"
    
    echo "✅ Workflow completed"
}

# Main
case "${1:-help}" in
    analyze)
        analyze_task "$2"
        ;;
    execute)
        execute_workflow "$2"
        ;;
    list)
        echo "Recent workflows:"
        ls -t "$NEXUS_ROOT/core/orchestrator/workflows" 2>/dev/null | head -10
        ;;
    *)
        echo "Usage: orchestrator.sh [analyze|execute|list] <args>"
        ;;
esac
