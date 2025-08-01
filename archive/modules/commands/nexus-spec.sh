#!/bin/bash
# NEXUS Spec Generator with Persona Integration

source "$(dirname "${BASH_SOURCE[0]}")/../personas/persona-integration.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../agents/subagent-handler.sh"

# Generate spec with persona context
generate_spec() {
    local spec_description="$1"
    local persona_id="${2:-$(cat "$ACTIVE_PERSONA_FILE" 2>/dev/null)}"
    
    # Check for active persona
    if [ -z "$persona_id" ] || [ ! -f "$PROJECT_PERSONAS/${persona_id}.yaml" ]; then
        echo -e "${YELLOW}Warning: No active persona set${NC}"
        echo "Specs are more effective with a target persona."
        echo "Set one with: /nexus/persona set <persona-id>"
        echo
    else
        local persona_name=$(grep "^name:" "$PROJECT_PERSONAS/${persona_id}.yaml" | cut -d' ' -f2-)
        echo -e "${GREEN}Generating spec for persona: $persona_name${NC}"
    fi
    
    # Create spec directory
    local spec_date=$(date +%Y-%m-%d)
    local spec_name=$(echo "$spec_description" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | cut -c1-30)
    local spec_dir=".nexus/specs/${spec_date}-${spec_name}"
    
    mkdir -p "$spec_dir"
    
    # Generate persona context
    local persona_context=""
    if [ -n "$persona_id" ]; then
        persona_context=$(get_persona_context "spec" "$persona_id")
    fi
    
    # Create spec with persona template
    local template_file
    if [ -n "$persona_id" ]; then
        template_file="$NEXUS_ROOT/modules/workflows/specs/spec-with-persona.md"
    else
        template_file="$NEXUS_ROOT/modules/workflows/specs/spec-template.md"
    fi
    
    # Copy and customize template
    if [ -f "$template_file" ]; then
        cp "$template_file" "$spec_dir/spec.md"
        
        # If persona exists, inject context
        if [ -n "$persona_id" ]; then
            local persona_file="$PROJECT_PERSONAS/${persona_id}.yaml"
            local persona_name=$(grep "^name:" "$persona_file" | cut -d' ' -f2-)
            local archetype=$(grep "^archetype:" "$persona_file" | cut -d' ' -f2-)
            local tech_level=$(grep "^technical_level:" "$persona_file" | cut -d' ' -f2-)
            
            # Update template with persona info
            sed -i '' "s/\[Active Persona Name\]/$persona_name/g" "$spec_dir/spec.md"
            sed -i '' "s/\[Archetype\]/$archetype/g" "$spec_dir/spec.md"
            sed -i '' "s/\[Persona Technical Level\]/$tech_level/g" "$spec_dir/spec.md"
            sed -i '' "s/\[Feature Name\]/$spec_description/g" "$spec_dir/spec.md"
        fi
    fi
    
    echo
    echo "Spec created at: $spec_dir/spec.md"
    echo
    echo "Next steps:"
    echo "1. Edit the spec with full details"
    echo "2. Review with stakeholders"
    echo "3. Generate tasks: /nexus/tasks $spec_dir/spec.md"
    
    # Launch architect agent with persona context
    if [ -n "$persona_context" ]; then
        export PERSONA_CONTEXT="$persona_context"
    fi
    
    echo
    echo "Launching architect to help with spec..."
    handle_subagent_task "architect" "Create detailed spec for: $spec_description" "architect"
}

# Main execution
case "${1:-help}" in
    generate)
        shift
        generate_spec "$@"
        ;;
    help|*)
        cat << EOF
NEXUS Spec Generator with Persona Support

Usage: $0 generate <spec-description> [persona-id]

Generates a specification document considering the active or specified persona.

Examples:
  $0 generate "user authentication system"
  $0 generate "dashboard widgets" sarah-chen

The spec will be tailored to the persona's:
- Technical level
- Goals and pain points  
- Usage context
- Success criteria

Set an active persona first:
  /nexus/persona set <persona-id>
EOF
        ;;
esac