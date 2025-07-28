#!/bin/bash
# NEXUS Post-Tool Logger

# Find NEXUS root relative to this script
NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Read the input JSON
input=$(cat)


# Extract tool name from Claude Code hook format
tool=$(echo "$input" | jq -r '.tool_name // "unknown"')

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Log tool usage for learning
log_file="$NEXUS_ROOT/self/metrics/tool-usage.jsonl"
mkdir -p "$(dirname "$log_file")"

# Extract meaningful data from the input
# Claude Code uses tool_input for parameters and tool_response for results
parameters=$(echo "$input" | jq -c '.tool_input // {}')

# Extract result information
result_type=$(echo "$input" | jq -r '.tool_response | type // "null"')

result_size=$(echo "$input" | jq -r '
    if .tool_response then 
        if (.tool_response | type) == "string" then .tool_response | length
        elif .tool_response.stdout then .tool_response.stdout | length
        elif .tool_response | type == "object" then .tool_response | tostring | length
        else 0
        end
    else 0
    end
')

# Create log entry
log_entry=$(jq -n \
    --arg time "$timestamp" \
    --arg tool "$tool" \
    --arg params "$parameters" \
    --arg rtype "$result_type" \
    --arg rsize "$result_size" \
    '{
        timestamp: $time,
        tool: $tool,
        parameters: $params,
        result_type: $rtype,
        result_size: $rsize
    }')

# Append to log
echo "$log_entry" >> "$log_file"

# Pass through
echo '{"logged": true}'