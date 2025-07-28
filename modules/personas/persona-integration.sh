#!/bin/bash
# NEXUS Persona Integration - Integrate personas into agent workflows

source "$(dirname "${BASH_SOURCE[0]}")/persona-manager.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../agents/subagent-handler.sh"

# Get persona context for current task
get_persona_context() {
    local task_type="$1"
    local explicit_persona="$2"
    
    # Get persona (explicit or active)
    local persona_json
    if [ -n "$explicit_persona" ]; then
        persona_json=$(export_persona_context "$explicit_persona")
    else
        persona_json=$(export_persona_context)
    fi
    
    # Return empty if no persona
    if [ "$persona_json" = "{}" ]; then
        echo ""
        return
    fi
    
    # Format context based on task type
    case "$task_type" in
        spec|story)
            echo "Design for persona: $(echo "$persona_json" | jq -r '.name') ($(echo "$persona_json" | jq -r '.archetype'))"
            echo "Technical level: $(echo "$persona_json" | jq -r '.technical_level')"
            echo "Primary goal: $(echo "$persona_json" | jq -r '.primary_goal')"
            ;;
        design)
            echo "User: $(echo "$persona_json" | jq -r '.name')"
            echo "Type: $(echo "$persona_json" | jq -r '.archetype')"
            echo "Skill: $(echo "$persona_json" | jq -r '.technical_level')"
            ;;
        *)
            echo "For: $(echo "$persona_json" | jq -r '.archetype')"
            ;;
    esac
}

# Enhance spec generation with persona
generate_spec_with_persona() {
    local spec_description="$1"
    local persona_context=$(get_persona_context "spec")
    
    if [ -n "$persona_context" ]; then
        echo "Generating spec with persona context:"
        echo "$persona_context"
        echo
        echo "Spec: $spec_description"
        
        # Add persona to spec generation prompt
        export PERSONA_CONTEXT="$persona_context"
    else
        echo "Generating spec: $spec_description"
        echo "(No active persona - consider setting one for better user focus)"
    fi
}

# Enhance user story with persona
enhance_user_story() {
    local feature="$1"
    local persona_id="${2:-$(cat "$ACTIVE_PERSONA_FILE" 2>/dev/null)}"
    
    if [ -z "$persona_id" ] || [ ! -f "$PROJECT_PERSONAS/${persona_id}.yaml" ]; then
        # Fallback to generic user story
        echo "As a user,"
        echo "I want to $feature,"
        echo "So that I can achieve my goals"
        return
    fi
    
    # Extract persona details for rich user story
    local persona_file="$PROJECT_PERSONAS/${persona_id}.yaml"
    local name=$(grep "^name:" "$persona_file" | cut -d' ' -f2-)
    local archetype=$(grep "^archetype:" "$persona_file" | cut -d' ' -f2-)
    local primary_goal=$(grep -A1 "primary:" "$persona_file" | tail -1 | sed 's/.*- //')
    local pain_point=$(grep -A1 "pain_points:" "$persona_file" | tail -1 | sed 's/.*- //')
    
    echo "=== User Story for $name ==="
    echo
    echo "As a $archetype,"
    echo "I want to $feature,"
    echo "So that I can $primary_goal"
    echo
    echo "Context:"
    echo "- Current pain point: $pain_point"
    echo "- This feature addresses their need for efficiency and clarity"
    echo
    echo "Acceptance Criteria:"
    echo "- [ ] Feature is accessible at their technical level"
    echo "- [ ] Workflow matches their usage patterns"
    echo "- [ ] Clear feedback and error handling"
    echo "- [ ] Performance meets their environment constraints"
}

# Suggest personas for project type
suggest_personas_for_project() {
    local project_type="$1"
    
    echo "Suggested personas for $project_type project:"
    echo
    
    case "$project_type" in
        *api*|*backend*|*service*)
            echo "1. Backend Developer - Primary user of the API"
            echo "2. Frontend Developer - Consumes the API"
            echo "3. DevOps Engineer - Deploys and monitors"
            ;;
        *web*|*app*|*frontend*)
            echo "1. End User - Primary audience"
            echo "2. Power User - Advanced features"
            echo "3. Administrator - Management tasks"
            ;;
        *tool*|*cli*|*developer*)
            echo "1. Senior Developer - Expert user"
            echo "2. Junior Developer - Learning user"
            echo "3. DevOps/SRE - Automation user"
            ;;
        *)
            echo "1. Primary User - Main audience"
            echo "2. Secondary User - Occasional use"
            echo "3. Administrator - System management"
            ;;
    esac
    
    echo
    echo "Create personas with: /nexus/persona create \"Name\" archetype"
}

# Check if persona should be used
should_use_persona() {
    local command="$1"
    
    case "$command" in
        spec|story|design|architect|designer|forge)
            return 0  # true - should use persona
            ;;
        *)
            return 1  # false - persona not needed
            ;;
    esac
}

# Inject persona into agent prompt
inject_persona_context() {
    local agent="$1"
    local original_prompt="$2"
    local persona_context=$(get_persona_context "$agent")
    
    if [ -n "$persona_context" ]; then
        echo "$original_prompt"
        echo
        echo "=== Active Persona Context ==="
        echo "$persona_context"
        echo "=== End Persona Context ==="
    else
        echo "$original_prompt"
    fi
}

# Export functions
export -f get_persona_context
export -f generate_spec_with_persona
export -f enhance_user_story
export -f suggest_personas_for_project
export -f should_use_persona
export -f inject_persona_context