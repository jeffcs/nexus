#!/bin/bash
# Nexus Evaluation Metrics Library

# Metric definitions and weights
declare -A METRICS=(
    ["response_quality"]=0.30
    ["task_completion"]=0.25
    ["collaboration_effectiveness"]=0.20
    ["pattern_adherence"]=0.15
    ["user_satisfaction"]=0.10
)

# Metric criteria
declare -A RESPONSE_QUALITY_CRITERIA=(
    ["relevance"]="Response addresses the user's request"
    ["completeness"]="All aspects of the request are covered"
    ["clarity"]="Response is clear and well-structured"
    ["actionability"]="Provides concrete next steps"
)

declare -A TASK_COMPLETION_CRITERIA=(
    ["requirements_met"]="All stated requirements fulfilled"
    ["deliverables_created"]="Expected outputs produced"
    ["no_hallucinations"]="No false information provided"
    ["error_free"]="No errors in execution"
)

declare -A COLLABORATION_CRITERIA=(
    ["handoff_clarity"]="Clear communication between agents"
    ["context_preservation"]="Context maintained across agents"
    ["agent_coordination"]="Appropriate agent activation"
    ["workflow_efficiency"]="Minimal redundancy"
)

declare -A PATTERN_ADHERENCE_CRITERIA=(
    ["follows_patterns"]="Uses documented patterns"
    ["applies_learnings"]="Incorporates taught behaviors"
    ["consistency"]="Consistent with past behavior"
    ["best_practices"]="Follows framework best practices"
)

# Calculate overall score
calculate_overall_score() {
    local scores_json="$1"
    local overall=0
    
    for metric in "${!METRICS[@]}"; do
        local weight="${METRICS[$metric]}"
        local score=$(echo "$scores_json" | jq -r ".$metric // 0")
        local weighted=$(echo "$score * $weight" | bc -l)
        overall=$(echo "$overall + $weighted" | bc -l)
    done
    
    printf "%.2f" "$overall"
}

# Evaluate response quality
evaluate_response_quality() {
    local response_file="$1"
    local task_context="$2"
    local score=0
    local max_score=0
    
    # Check each criterion
    for criterion in "${!RESPONSE_QUALITY_CRITERIA[@]}"; do
        max_score=$((max_score + 1))
        
        case "$criterion" in
            relevance)
                if check_relevance "$response_file" "$task_context"; then
                    score=$((score + 1))
                fi
                ;;
            completeness)
                if check_completeness "$response_file" "$task_context"; then
                    score=$((score + 1))
                fi
                ;;
            clarity)
                if check_clarity "$response_file"; then
                    score=$((score + 1))
                fi
                ;;
            actionability)
                if check_actionability "$response_file"; then
                    score=$((score + 1))
                fi
                ;;
        esac
    done
    
    # Return normalized score
    echo "scale=2; $score / $max_score" | bc -l
}

# Evaluate task completion
evaluate_task_completion() {
    local session_dir="$1"
    local expected_outputs="$2"
    local score=0
    local max_score=4
    
    # Check requirements
    if check_requirements_met "$session_dir" "$expected_outputs"; then
        score=$((score + 1))
    fi
    
    # Check deliverables
    if check_deliverables "$session_dir" "$expected_outputs"; then
        score=$((score + 1))
    fi
    
    # Check for hallucinations
    if ! has_hallucinations "$session_dir"; then
        score=$((score + 1))
    fi
    
    # Check for errors
    if ! has_errors "$session_dir"; then
        score=$((score + 1))
    fi
    
    echo "scale=2; $score / $max_score" | bc -l
}

# Evaluate collaboration effectiveness
evaluate_collaboration() {
    local session_dir="$1"
    local interaction_log="$session_dir/interactions.json"
    local score=0
    local max_score=4
    
    if [[ ! -f "$interaction_log" ]]; then
        echo "0.5"  # Default middle score if no collaboration
        return
    fi
    
    # Check handoff clarity
    if check_handoff_clarity "$interaction_log"; then
        score=$((score + 1))
    fi
    
    # Check context preservation
    if check_context_preservation "$interaction_log"; then
        score=$((score + 1))
    fi
    
    # Check agent coordination
    if check_agent_coordination "$interaction_log"; then
        score=$((score + 1))
    fi
    
    # Check workflow efficiency
    if check_workflow_efficiency "$interaction_log"; then
        score=$((score + 1))
    fi
    
    echo "scale=2; $score / $max_score" | bc -l
}

# Evaluate pattern adherence
evaluate_pattern_adherence() {
    local agent="$1"
    local session_dir="$2"
    local patterns_file="$NEXUS_ROOT/.nexus/patterns/$agent.md"
    local score=0
    local max_score=4
    
    if [[ ! -f "$patterns_file" ]]; then
        echo "1.0"  # Perfect score if no patterns to follow
        return
    fi
    
    # Check pattern usage
    if check_pattern_usage "$session_dir" "$patterns_file"; then
        score=$((score + 1))
    fi
    
    # Check applied learnings
    if check_applied_learnings "$session_dir" "$agent"; then
        score=$((score + 1))
    fi
    
    # Check consistency
    if check_consistency "$session_dir" "$agent"; then
        score=$((score + 1))
    fi
    
    # Check best practices
    if check_best_practices "$session_dir" "$agent"; then
        score=$((score + 1))
    fi
    
    echo "scale=2; $score / $max_score" | bc -l
}

# Helper functions for checks (simplified for POC)
check_relevance() {
    # Check if response addresses the task
    local response_file="$1"
    local task_context="$2"
    
    # Simple keyword matching for now
    grep -q -i "$(echo "$task_context" | awk '{print $1}')" "$response_file"
}

check_completeness() {
    # Check if all aspects are covered
    local response_file="$1"
    local min_length=100
    
    [[ $(wc -c < "$response_file") -gt $min_length ]]
}

check_clarity() {
    # Check response structure
    local response_file="$1"
    
    # Look for structure markers
    grep -q -E "(##|###|\*|1\.|Problem|Solution|Steps)" "$response_file"
}

check_actionability() {
    # Check for concrete next steps
    local response_file="$1"
    
    grep -q -iE "(next steps|to do|action|implement|create|build)" "$response_file"
}

check_requirements_met() {
    # Check if requirements were fulfilled
    local session_dir="$1"
    local requirements_file="$session_dir/requirements.json"
    
    if [[ -f "$requirements_file" ]]; then
        # Check completion status
        local completed=$(jq -r '.requirements[] | select(.status == "completed") | length' "$requirements_file" | wc -l)
        local total=$(jq -r '.requirements | length' "$requirements_file")
        [[ "$completed" -eq "$total" ]]
    else
        true  # No requirements means success
    fi
}

check_deliverables() {
    # Check if expected files/outputs exist
    local session_dir="$1"
    local deliverables_file="$session_dir/expected_deliverables.json"
    
    if [[ -f "$deliverables_file" ]]; then
        while read -r deliverable; do
            if [[ ! -f "$session_dir/outputs/$deliverable" ]]; then
                return 1
            fi
        done < <(jq -r '.[]' "$deliverables_file")
    fi
    
    return 0
}

has_hallucinations() {
    # Check for false information
    local session_dir="$1"
    local hallucination_log="$session_dir/hallucinations.log"
    
    [[ -f "$hallucination_log" && -s "$hallucination_log" ]]
}

has_errors() {
    # Check for execution errors
    local session_dir="$1"
    local error_log="$session_dir/errors.log"
    
    [[ -f "$error_log" && -s "$error_log" ]]
}

# Export all metrics functions
export -f calculate_overall_score
export -f evaluate_response_quality
export -f evaluate_task_completion
export -f evaluate_collaboration
export -f evaluate_pattern_adherence