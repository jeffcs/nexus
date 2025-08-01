#!/bin/bash
# NEXUS Persona Manager - Create and manage user personas for design decisions

source "$(dirname "${BASH_SOURCE[0]}")/../core/common.sh"

# Persona storage paths
PERSONA_VAULT="$NEXUS_ROOT/vault/personas"
PROJECT_PERSONAS=".nexus/personas"
ACTIVE_PERSONA_FILE=".nexus/active-persona"

# Initialize persona directories
init_personas() {
    mkdir -p "$PERSONA_VAULT"
    mkdir -p "$PROJECT_PERSONAS"
    
    # Create default persona template
    if [ ! -f "$PERSONA_VAULT/template.yaml" ]; then
        create_persona_template
    fi
}

# Create persona template
create_persona_template() {
    cat > "$PERSONA_VAULT/template.yaml" << 'EOF'
id: [unique-identifier]
name: [Full Name]
archetype: [User Type - e.g., Power User, Casual User, Administrator]
age: [Age or range]
occupation: [Job Title/Role]
technical_level: [Novice/Intermediate/Expert]

demographics:
  location: [Geographic location]
  industry: [Industry/Domain]
  company_size: [Solo/Small/Medium/Enterprise]

goals:
  primary:
    - [Main objective when using the product]
  secondary:
    - [Additional goals]
    - [Nice-to-have outcomes]

pain_points:
  - [Current frustration or problem]
  - [Time-consuming tasks]
  - [Technical barriers]

behaviors:
  - daily_usage: [How often they use similar products]
  - preferred_devices: [Desktop/Mobile/Tablet]
  - work_style: [Individual/Collaborative]
  - learning_preference: [Visual/Written/Video/Hands-on]

needs:
  functional:
    - [Core functionality requirements]
    - [Must-have features]
  emotional:
    - [How they want to feel using the product]
    - [Psychological needs]

quote: "[Something this persona might say about their needs]"

scenarios:
  - name: [Scenario name]
    context: [When/where this happens]
    trigger: [What initiates this scenario]
    actions: [What they need to do]
    success: [What success looks like]

accessibility:
  - [Any accessibility requirements]
  - [Assistive technologies used]

technical_constraints:
  - [Browser limitations]
  - [Network conditions]
  - [Device constraints]
EOF
    echo "Created persona template at $PERSONA_VAULT/template.yaml"
}

# Create a new persona
create_persona() {
    local persona_name="$1"
    local persona_type="${2:-custom}"
    
    if [ -z "$persona_name" ]; then
        echo "Error: Persona name required"
        echo "Usage: $0 create <name> [type]"
        return 1
    fi
    
    local persona_id=$(echo "$persona_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    local persona_file="$PROJECT_PERSONAS/${persona_id}.yaml"
    
    if [ -f "$persona_file" ]; then
        echo "Persona '$persona_name' already exists"
        return 1
    fi
    
    # Copy template or archetype
    local source_file="$PERSONA_VAULT/template.yaml"
    if [ "$persona_type" != "custom" ] && [ -f "$PERSONA_VAULT/archetypes/${persona_type}.yaml" ]; then
        source_file="$PERSONA_VAULT/archetypes/${persona_type}.yaml"
    fi
    
    cp "$source_file" "$persona_file"
    
    # Update basic fields
    sed -i '' "s/id: .*/id: $persona_id/" "$persona_file"
    sed -i '' "s/name: .*/name: $persona_name/" "$persona_file"
    
    echo "Created persona: $persona_name"
    echo "Edit: $persona_file"
    
    # Set as active if first persona
    if [ ! -f "$ACTIVE_PERSONA_FILE" ]; then
        set_active_persona "$persona_id"
    fi
}

# List all personas
list_personas() {
    echo -e "${BLUE}Available Personas:${NC}"
    echo
    
    # Get active persona
    local active_persona=""
    [ -f "$ACTIVE_PERSONA_FILE" ] && active_persona=$(cat "$ACTIVE_PERSONA_FILE")
    
    # List project personas
    if [ -d "$PROJECT_PERSONAS" ]; then
        for persona in "$PROJECT_PERSONAS"/*.yaml; do
            [ -f "$persona" ] || continue
            
            local id=$(basename "$persona" .yaml)
            local name=$(grep "^name:" "$persona" | cut -d' ' -f2-)
            local archetype=$(grep "^archetype:" "$persona" | cut -d' ' -f2-)
            
            if [ "$id" = "$active_persona" ]; then
                echo -e "  ${GREEN}● $name${NC} ($archetype) ${GREEN}[ACTIVE]${NC}"
            else
                echo -e "  ○ $name ($archetype)"
            fi
        done
    fi
    
    # List archetypes
    echo
    echo -e "${YELLOW}Available Archetypes:${NC}"
    if [ -d "$PERSONA_VAULT/archetypes" ]; then
        for archetype in "$PERSONA_VAULT/archetypes"/*.yaml; do
            [ -f "$archetype" ] || continue
            local name=$(basename "$archetype" .yaml)
            echo "  - $name"
        done
    fi
}

# Set active persona
set_active_persona() {
    local persona_id="$1"
    
    if [ -z "$persona_id" ]; then
        echo "Error: Persona ID required"
        return 1
    fi
    
    if [ ! -f "$PROJECT_PERSONAS/${persona_id}.yaml" ]; then
        echo "Error: Persona '$persona_id' not found"
        return 1
    fi
    
    echo "$persona_id" > "$ACTIVE_PERSONA_FILE"
    
    local name=$(grep "^name:" "$PROJECT_PERSONAS/${persona_id}.yaml" | cut -d' ' -f2-)
    echo "Active persona set to: $name"
}

# Get active persona details
get_active_persona() {
    if [ ! -f "$ACTIVE_PERSONA_FILE" ]; then
        echo "No active persona set"
        return 1
    fi
    
    local persona_id=$(cat "$ACTIVE_PERSONA_FILE")
    local persona_file="$PROJECT_PERSONAS/${persona_id}.yaml"
    
    if [ ! -f "$persona_file" ]; then
        echo "Active persona file not found"
        return 1
    fi
    
    cat "$persona_file"
}

# Generate user story for persona
generate_user_story() {
    local feature="$1"
    local persona_id="${2:-$(cat "$ACTIVE_PERSONA_FILE" 2>/dev/null)}"
    
    if [ -z "$persona_id" ]; then
        echo "Error: No persona specified or active"
        return 1
    fi
    
    local persona_file="$PROJECT_PERSONAS/${persona_id}.yaml"
    if [ ! -f "$persona_file" ]; then
        echo "Error: Persona not found"
        return 1
    fi
    
    # Extract persona details
    local name=$(grep "^name:" "$persona_file" | cut -d' ' -f2-)
    local archetype=$(grep "^archetype:" "$persona_file" | cut -d' ' -f2-)
    local primary_goal=$(grep -A1 "primary:" "$persona_file" | tail -1 | sed 's/.*- //')
    
    echo "User Story for: $name ($archetype)"
    echo
    echo "As a $archetype,"
    echo "I want to $feature,"
    echo "So that I can $primary_goal"
    echo
    echo "Context from persona:"
    grep -A5 "^goals:" "$persona_file"
}

# Create persona archetype
create_archetype() {
    local archetype_name="$1"
    
    mkdir -p "$PERSONA_VAULT/archetypes"
    
    case "$archetype_name" in
        "developer")
            cat > "$PERSONA_VAULT/archetypes/developer.yaml" << 'EOF'
id: developer-archetype
name: Developer Archetype
archetype: Software Developer
age: 25-40
occupation: Full-Stack Developer
technical_level: Expert

demographics:
  location: Global
  industry: Technology
  company_size: Small/Medium/Enterprise

goals:
  primary:
    - Build robust, maintainable software efficiently
    - Automate repetitive tasks
    - Improve code quality and performance
  secondary:
    - Learn new technologies and patterns
    - Collaborate effectively with team
    - Ship features quickly without sacrificing quality

pain_points:
  - Context switching between multiple projects
  - Debugging complex issues without proper tools
  - Maintaining consistency across large codebases
  - Documentation that's outdated or missing

behaviors:
  - daily_usage: 8-10 hours
  - preferred_devices: Desktop with multiple monitors
  - work_style: Individual with collaborative sprints
  - learning_preference: Hands-on with documentation reference

needs:
  functional:
    - Fast, keyboard-driven interfaces
    - Powerful search and navigation
    - Integration with existing tools (Git, IDE, CI/CD)
    - Clear error messages and debugging info
  emotional:
    - Feel productive and in control
    - Confidence in code quality
    - Sense of progress and achievement

quote: "I need tools that get out of my way and let me focus on solving problems"

scenarios:
  - name: Feature Implementation
    context: Starting a new feature from a ticket
    trigger: Assigned a new task in sprint
    actions: Design, implement, test, and deploy
    success: Feature works, tests pass, code is maintainable

accessibility:
  - Keyboard navigation essential
  - High contrast themes for long coding sessions
  - Screen reader compatibility for pair programming

technical_constraints:
  - Terminal-based workflows
  - Version control integration required
  - Must work offline
EOF
            ;;
            
        "designer")
            cat > "$PERSONA_VAULT/archetypes/designer.yaml" << 'EOF'
id: designer-archetype
name: Designer Archetype
archetype: UX/UI Designer
age: 23-35
occupation: Product Designer
technical_level: Intermediate

demographics:
  location: Urban centers
  industry: Design/Technology
  company_size: Startup/Medium

goals:
  primary:
    - Create intuitive, beautiful user experiences
    - Maintain design consistency across products
    - Validate designs with user feedback
  secondary:
    - Collaborate smoothly with developers
    - Build and evolve design systems
    - Improve accessibility and inclusion

pain_points:
  - Design-to-development handoff friction
  - Maintaining design system documentation
  - Balancing user needs with technical constraints
  - Communicating design decisions effectively

behaviors:
  - daily_usage: 6-8 hours
  - preferred_devices: Desktop with tablet for sketching
  - work_style: Collaborative with focused design time
  - learning_preference: Visual with case studies

needs:
  functional:
    - Visual design tools with developer handoff
    - Component libraries and design systems
    - Prototyping and user testing capabilities
    - Version control for design files
  emotional:
    - Feel creative and empowered
    - See designs come to life accurately
    - Pride in user satisfaction

quote: "Good design is invisible - users should focus on their goals, not the interface"

scenarios:
  - name: Component Design
    context: Creating a new UI component
    trigger: New feature requires custom component
    actions: Research, sketch, prototype, spec, handoff
    success: Component is reusable, accessible, and implemented correctly

accessibility:
  - Color contrast checking tools
  - Screen reader testing capability
  - Keyboard navigation verification
  - WCAG compliance validation

technical_constraints:
  - Must export to developer-friendly formats
  - Real device preview required
  - Performance impact awareness
EOF
            ;;
            
        "product-manager")
            cat > "$PERSONA_VAULT/archetypes/product-manager.yaml" << 'EOF'
id: pm-archetype
name: Product Manager Archetype
archetype: Product Manager
age: 28-45
occupation: Senior Product Manager
technical_level: Intermediate

demographics:
  location: Global
  industry: Technology/SaaS
  company_size: Medium/Enterprise

goals:
  primary:
    - Deliver value to users and business
    - Make data-driven product decisions
    - Align team around product vision
  secondary:
    - Balance stakeholder needs
    - Manage product roadmap effectively
    - Measure and improve product metrics

pain_points:
  - Translating user needs to technical requirements
  - Prioritizing features with limited resources
  - Keeping everyone aligned on product direction
  - Measuring actual user value delivered

behaviors:
  - daily_usage: Throughout the day in bursts
  - preferred_devices: Laptop with mobile for on-the-go
  - work_style: Highly collaborative
  - learning_preference: Data and case studies

needs:
  functional:
    - Clear visibility into development progress
    - User feedback and analytics integration
    - Roadmap planning and communication tools
    - Specification templates and workflows
  emotional:
    - Confidence in product decisions
    - Feel connected to user needs
    - Sense of forward momentum

quote: "I need to understand what users truly need, not just what they ask for"

scenarios:
  - name: Feature Prioritization
    context: Sprint planning with limited resources
    trigger: Multiple feature requests competing
    actions: Analyze impact, effort, and value
    success: Team aligned on highest-value work

accessibility:
  - Mobile-friendly interfaces for remote work
  - Clear visual hierarchy for quick scanning
  - Export capabilities for stakeholder reports

technical_constraints:
  - Must integrate with existing PM tools
  - Real-time collaboration required
  - Works across time zones
EOF
            ;;
    esac
    
    echo "Created archetype: $archetype_name"
}

# Export persona context for agents
export_persona_context() {
    local persona_id="${1:-$(cat "$ACTIVE_PERSONA_FILE" 2>/dev/null)}"
    
    if [ -z "$persona_id" ]; then
        echo "{}"
        return
    fi
    
    local persona_file="$PROJECT_PERSONAS/${persona_id}.yaml"
    if [ ! -f "$persona_file" ]; then
        echo "{}"
        return
    fi
    
    # Convert YAML to JSON for easier consumption
    # This is a simplified conversion - in production, use a proper YAML parser
    echo "{"
    echo "  \"id\": \"$persona_id\","
    echo "  \"name\": \"$(grep "^name:" "$persona_file" | cut -d' ' -f2-)\","
    echo "  \"archetype\": \"$(grep "^archetype:" "$persona_file" | cut -d' ' -f2-)\","
    echo "  \"technical_level\": \"$(grep "^technical_level:" "$persona_file" | cut -d' ' -f2-)\","
    echo "  \"primary_goal\": \"$(grep -A1 "primary:" "$persona_file" | tail -1 | sed 's/.*- //')\""
    echo "}"
}

# Main command handler
case "${1:-help}" in
    init)
        init_personas
        ;;
    create)
        create_persona "$2" "$3"
        ;;
    list)
        list_personas
        ;;
    set)
        set_active_persona "$2"
        ;;
    get)
        get_active_persona
        ;;
    story)
        generate_user_story "$2" "$3"
        ;;
    archetype)
        create_archetype "$2"
        ;;
    export)
        export_persona_context "$2"
        ;;
    help|*)
        cat << EOF
NEXUS Persona Manager

Usage: $0 <command> [options]

Commands:
  init                    Initialize persona system
  create <name> [type]    Create a new persona
  list                    List all personas
  set <persona-id>        Set active persona
  get                     Get active persona details
  story <feature> [id]    Generate user story for persona
  archetype <type>        Create persona archetype
  export [id]             Export persona context as JSON
  help                    Show this help message

Archetypes:
  developer              Software developer persona
  designer               UX/UI designer persona
  product-manager        Product manager persona

Examples:
  $0 create "Sarah Chen" developer
  $0 set sarah-chen
  $0 story "create dashboard widgets"

Personas help agents design features with specific users in mind,
ensuring solutions meet real user needs and constraints.
EOF
        ;;
esac