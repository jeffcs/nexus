#!/bin/bash
# NEXUS Post-Tool Logger

# Find NEXUS root relative to this script
NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Read the input JSON
input=$(cat)

# Extract tool name from the input - Claude sends it as 'toolName'
tool=$(echo "$input" | jq -r '.toolName // .tool // "unknown"')
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Log tool usage for learning
log_file="$NEXUS_ROOT/self/metrics/tool-usage.jsonl"
mkdir -p "$(dirname "$log_file")"

# Extract meaningful data from the input
parameters=$(echo "$input" | jq -c '.parameters // {}')
result_type=$(echo "$input" | jq -r '.result | type // "unknown"')
result_size=$(echo "$input" | jq -r '.result | if type == "string" then length else 0 end')

# Append to log with proper structure
echo "$input" | jq --arg time "$timestamp" \
                   --arg tool "$tool" \
                   --arg params "$parameters" \
                   --arg rtype "$result_type" \
                   --arg rsize "$result_size" '{
    timestamp: $time,
    tool: $tool,
    parameters: $params,
    result_type: $rtype,
    result_size: $rsize
}' >> "$log_file"

# Pass through
echo '{"logged": true}'