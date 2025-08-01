#!/bin/bash
# NEXUS Enhanced Subagent Handler with Orchestration Support

source "$(dirname "${BASH_SOURCE[0]}")/../core/common.sh"

# Communication directory for agent coordination
AGENT_COMM_DIR="/tmp/nexus/agent-comm"
mkdir -p "$AGENT_COMM_DIR"

# Map NEXUS agents to sub-agent prompts
declare -A AGENT_PROMPTS=(
    ["architect"]="/nexus/architect"
    ["forge"]="/nexus/forge"
    ["sentinel"]="/nexus/sentinel"
    ["phoenix"]="/nexus/phoenix"
    ["designer"]="/nexus/designer"
    ["researcher"]="/nexus/research"
)

# Enhanced subagent task handler
handle_subagent_task() {
    local task_type="$1"
    local task_description="$2"
    local agent="${3:-general}"
    
    log_info "🤖 Orchestrating subagent task: $task_type"
    
    # Create task ID for tracking
    local task_id=$(date +%s%N | md5sum | cut -c1-8)
    local task_file="$AGENT_COMM_DIR/task_$task_id.json"
    
    # Prepare task context
    cat > "$task_file" << EOF
{
    "task_id": "$task_id",
    "type": "$task_type",
    "description": "$task_description",
    "agent": "$agent",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "status": "pending"
}
EOF
    
    case "$task_type" in
        "research")
            echo "🔍 Research Task: $task_description"
            echo "Agent: Specialized researcher with deep analysis capabilities"
            echo "Approach: Comprehensive search, pattern analysis, best practices"
            ;;
        "architect")
            echo "🏗️ Architecture Task: $task_description"
            echo "Agent: System architect for design and structure"
            echo "Approach: System thinking, scalability, maintainability"
            ;;
        "implement")
            echo "⚡ Implementation Task: $task_description"
            echo "Agent: Forge for code generation and pattern application"
            echo "Approach: Clean code, established patterns, performance"
            ;;
        "design")
            echo "🎨 Design Task: $task_description"
            echo "Agent: UI/UX designer for interface specifications"
            echo "Approach: User-centered, accessible, implementable"
            ;;
        "test")
            echo "🛡️ Testing Task: $task_description"
            echo "Agent: Sentinel for quality assurance"
            echo "Approach: Comprehensive coverage, edge cases, security"
            ;;
        "evolve")
            echo "🔄 Evolution Task: $task_description"
            echo "Agent: Phoenix for pattern extraction and learning"
            echo "Approach: Pattern mining, knowledge synthesis, optimization"
            ;;
        "parallel")
            echo "🚀 Parallel Execution: $task_description"
            handle_parallel_tasks "$task_description"
            ;;
        *)
            echo "📋 General Task: $task_description"
            echo "Agent: General-purpose with full capabilities"
            ;;
    esac
    
    # Mark task as dispatched
    jq '.status = "dispatched"' "$task_file" > "$task_file.tmp" && mv "$task_file.tmp" "$task_file"
}

# Handle parallel task execution
handle_parallel_tasks() {
    local tasks_desc="$1"
    
    echo "═══════════════════════════════════════════════════════"
    echo "🚀 Parallel Task Orchestration"
    echo "═══════════════════════════════════════════════════════"
    echo
    echo "Tasks will be distributed across specialized sub-agents:"
    echo
    
    # Parse parallel tasks (format: agent1:task1;agent2:task2)
    IFS=';' read -ra TASKS <<< "$tasks_desc"
    for i in "${!TASKS[@]}"; do
        IFS=':' read -r agent task <<< "${TASKS[$i]}"
        echo "  $((i+1)). ${agent^}: $task"
    done
    
    echo
    echo "Benefits of parallel execution:"
    echo "  • Isolated contexts prevent interference"
    echo "  • Specialized agents for each domain"
    echo "  • Faster completion through concurrency"
    echo "  • Better quality through focus"
}

# Synthesize results from multiple agents
synthesize_agent_results() {
    local task_pattern="${1:-*}"
    
    echo "📊 Synthesizing results from sub-agents..."
    
    local results=()
    for task_file in "$AGENT_COMM_DIR"/task_${task_pattern}.json; do
        [ -f "$task_file" ] || continue
        
        local task_info=$(jq -r '. | "\(.agent): \(.description) [\(.status)]"' "$task_file")
        results+=("$task_info")
    done
    
    if [ ${#results[@]} -gt 0 ]; then
        echo "Found ${#results[@]} agent results:"
        printf '  • %s\n' "${results[@]}"
    else
        echo "No results found for pattern: $task_pattern"
    fi
}

# Get recommended agent for task type
recommend_agent() {
    local task_desc="$1"
    
    # Simple keyword matching for agent recommendation
    case "$task_desc" in
        *design*|*ui*|*ux*|*interface*)
            echo "designer"
            ;;
        *architect*|*structure*|*system*)
            echo "architect"
            ;;
        *implement*|*code*|*build*)
            echo "forge"
            ;;
        *test*|*quality*|*security*)
            echo "sentinel"
            ;;
        *learn*|*pattern*|*evolve*)
            echo "phoenix"
            ;;
        *research*|*analyze*|*investigate*)
            echo "researcher"
            ;;
        *)
            echo "general"
            ;;
    esac
}

# Export functions for use in NEXUS
export -f handle_subagent_task
export -f handle_parallel_tasks
export -f synthesize_agent_results
export -f recommend_agent
