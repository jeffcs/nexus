#!/bin/bash
# NEXUS Prompt Enhancer Hook

# Read the input JSON
input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // ""')

# Check if prompt mentions NEXUS concepts
if [[ "$prompt" =~ nexus|agent|evolve|forge|genesis|architect|sentinel|phoenix ]]; then
    # Add NEXUS context
    echo "🧬 NEXUS Context Enhancement Active" >&2
    
    # Get current version
    version=$(jq -r .version "$NEXUS_ROOT/self/dna/version.json" 2>/dev/null || echo "0.1.0")
    
    # Output enhanced prompt
    jq -n --arg prompt "$prompt" --arg ver "$version" '{
        prompt: ($prompt + "\n\n[NEXUS v" + $ver + " - Evolution Engine Active]"),
        metadata: {
            nexus_version: $ver,
            enhancement: "context_added"
        }
    }'
else
    # Pass through unchanged
    echo "$input"
fi
