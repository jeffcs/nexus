#!/bin/bash
# NEXUS Pre-Tool Validator

# Read the input JSON
input=$(cat)
tool=$(echo "$input" | jq -r '.tool // ""')
path=$(echo "$input" | jq -r '.parameters.file_path // .parameters.path // ""')

# Validate NEXUS file modifications
if [[ "$path" =~ nexus/self/dna/core\.nexus ]]; then
    echo "⚠️  NEXUS DNA modification detected - validating..." >&2
    
    # Check if evolution is active
    if [ -f "$NEXUS_ROOT/.evolution-in-progress" ]; then
        echo '{"decision": "allow", "message": "Evolution in progress - modification allowed"}' 
    else
        echo '{"decision": "block", "message": "NEXUS DNA can only be modified during evolution. Run /evolve first."}' 
    fi
else
    # Allow other operations
    echo '{"decision": "allow"}'
fi
