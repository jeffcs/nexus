#!/bin/bash
# NEXUS Workflow Engine - Spec-driven development

create_spec() {
    local spec_name="$1"
    local spec_date=$(date +%Y-%m-%d)
    local spec_dir="$NEXUS_ROOT/vault/specs/$spec_date-$spec_name"
    
    mkdir -p "$spec_dir/sub-specs"
    
    # Copy template
    cp "$NEXUS_ROOT/modules/workflows/specs/spec-template.md" "$spec_dir/spec.md"
    
    # Create task breakdown
    cat > "$spec_dir/tasks.md" << 'TASKS'
# Spec Tasks

## Tasks

- [ ] 1. [Major task description]
  - [ ] 1.1 Write tests
  - [ ] 1.2 Implement feature
  - [ ] 1.3 Verify tests pass

- [ ] 2. [Major task description]
  - [ ] 2.1 Write tests
  - [ ] 2.2 Implement feature
TASKS
    
    echo "✅ Created spec: $spec_dir"
    echo "📝 Next: Edit $spec_dir/spec.md to define requirements"
}

execute_spec() {
    local spec_path="$1"
    local task_id="$2"
    
    if [ -f "$spec_path/tasks.md" ]; then
        echo "📋 Executing spec: $(basename "$spec_path")"
        echo "🎯 Task: $task_id"
        
        # Mark task as in progress
        sed -i '' "s/\[ \] $task_id/\[\*\] $task_id/" "$spec_path/tasks.md" 2>/dev/null
        
        echo "⚡ Task marked as in progress"
        echo "💡 Use appropriate agents to complete the task"
    fi
}

export -f create_spec execute_spec
