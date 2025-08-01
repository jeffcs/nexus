#!/bin/bash
# NEXUS Memory System

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MEMORY_DB="$NEXUS_ROOT/core/memory/nexus-memory.json"

# Initialize memory
init_memory() {
    if [ ! -f "$MEMORY_DB" ]; then
        mkdir -p "$(dirname "$MEMORY_DB")"
        echo '{"agents": {}, "patterns": [], "decisions": []}' > "$MEMORY_DB"
        echo "✓ Memory system initialized"
    fi
}

# Store agent memory
store_agent_memory() {
    local agent="$1"
    local key="$2"
    local value="$3"
    
    init_memory
    
    # Update memory
    jq --arg agent "$agent" --arg key "$key" --arg value "$value" \
        '.agents[$agent][$key] = $value' "$MEMORY_DB" > "$MEMORY_DB.tmp"
    mv "$MEMORY_DB.tmp" "$MEMORY_DB"
    
    echo "✓ Stored memory for $agent: $key"
}

# Recall agent memory
recall_agent_memory() {
    local agent="$1"
    local key="$2"
    
    if [ -f "$MEMORY_DB" ]; then
        jq -r --arg agent "$agent" --arg key "$key" \
            '.agents[$agent][$key] // "no memory"' "$MEMORY_DB"
    else
        echo "no memory"
    fi
}

# Store pattern
store_pattern() {
    local pattern="$1"
    local context="$2"
    
    init_memory
    
    # Add pattern
    jq --arg pattern "$pattern" --arg context "$context" \
        '.patterns += [{"pattern": $pattern, "context": $context, "timestamp": now}]' \
        "$MEMORY_DB" > "$MEMORY_DB.tmp"
    mv "$MEMORY_DB.tmp" "$MEMORY_DB"
    
    echo "✓ Pattern stored"
}

# Main
case "${1:-help}" in
    init)
        init_memory
        ;;
    store)
        store_agent_memory "$2" "$3" "$4"
        ;;
    recall)
        recall_agent_memory "$2" "$3"
        ;;
    pattern)
        store_pattern "$2" "$3"
        ;;
    *)
        echo "Usage: memory-system.sh [init|store|recall|pattern] <args>"
        ;;
esac
