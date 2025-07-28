#!/bin/bash
# NEXUS Post-Tool Logger

# Read the input JSON
input=$(cat)
tool=$(echo "$input" | jq -r '.tool // ""')
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Log tool usage for learning
log_file="$NEXUS_ROOT/self/metrics/tool-usage.jsonl"
mkdir -p "$(dirname "$log_file")"

# Append to log
echo "$input" | jq --arg time "$timestamp" --arg tool "$tool" '{
    timestamp: $time,
    tool: $tool,
    parameters: .parameters,
    result_summary: (.result | type)
}' >> "$log_file"

# Pass through
echo '{"logged": true}'
