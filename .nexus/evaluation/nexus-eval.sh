#!/bin/bash
# Nexus Evaluation Framework
# Main entry point for agent testing and evaluation

set -e

# Configuration
NEXUS_ROOT="${NEXUS_ROOT:-$(dirname $(dirname $(dirname "$0")))}"
EVAL_DIR="$NEXUS_ROOT/.nexus/evaluation"
RESULTS_DIR="$EVAL_DIR/results"
VERSIONS_DIR="$EVAL_DIR/versions"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Ensure directories exist
mkdir -p "$RESULTS_DIR" "$VERSIONS_DIR"

# Load evaluation metrics
source "$EVAL_DIR/lib/metrics.sh"
source "$EVAL_DIR/lib/evaluators.sh"

# Command handlers
cmd_test() {
    local agent_version="$1"
    local tasks="${2:-standard}"
    local compare_to="${3:-}"
    
    # Parse agent and version
    IFS=':' read -r agent version <<< "$agent_version"
    
    echo -e "${BLUE}🧪 Testing $agent ($version)${NC}"
    echo "Tasks: $tasks"
    
    # Create test session
    local session_id=$(date +%Y%m%d-%H%M%S)-$agent-$version
    local session_dir="$RESULTS_DIR/$session_id"
    mkdir -p "$session_dir"
    
    # Run test tasks
    run_test_suite "$agent" "$version" "$tasks" "$session_dir"
    
    # Evaluate results
    evaluate_session "$session_dir"
    
    # Compare if requested
    if [[ -n "$compare_to" ]]; then
        echo -e "\n${BLUE}📊 Comparing results...${NC}"
        compare_results "$session_id" "$compare_to"
    fi
    
    # Display summary
    display_results "$session_dir"
}

cmd_create() {
    local agent_version="$1"
    IFS=':' read -r agent variant <<< "$agent_version"
    
    local variant_dir="$VERSIONS_DIR/$agent"
    mkdir -p "$variant_dir"
    
    # Get base agent file
    local base_file="$NEXUS_ROOT/.claude/agents/$agent.md"
    local variant_file="$variant_dir/$variant.md"
    
    if [[ ! -f "$base_file" ]]; then
        echo -e "${RED}❌ Agent not found: $agent${NC}"
        exit 1
    fi
    
    # Copy base to create variant
    cp "$base_file" "$variant_file"
    echo -e "${GREEN}✅ Created variant: $agent:$variant${NC}"
    echo "Edit: $variant_file"
}

cmd_compare() {
    local versions="$1"
    IFS=',' read -ra version_array <<< "$versions"
    
    echo -e "${BLUE}📊 Comparing agent versions${NC}"
    echo "Versions: ${version_array[@]}"
    echo ""
    
    # Generate comparison report
    generate_comparison_report "${version_array[@]}"
}

cmd_monitor() {
    local agents="${1:-all}"
    local metrics="${2:-all}"
    
    echo -e "${BLUE}📈 Starting monitoring dashboard${NC}"
    echo "Agents: $agents"
    echo "Metrics: $metrics"
    
    # Start monitoring server (placeholder)
    "$EVAL_DIR/lib/monitor.sh" --agents "$agents" --metrics "$metrics"
}

cmd_analyze() {
    local period="${1:-7d}"
    local agent="${2:-all}"
    
    echo -e "${BLUE}🔍 Analyzing performance${NC}"
    echo "Period: $period"
    echo "Agent: $agent"
    
    # Run analysis
    analyze_performance "$period" "$agent"
}

cmd_suggest() {
    local agent="$1"
    local based_on="${2:-analysis}"
    
    echo -e "${BLUE}💡 Generating improvement suggestions${NC}"
    echo "Agent: $agent"
    echo "Based on: $based_on"
    
    # Generate suggestions
    generate_suggestions "$agent" "$based_on"
}

cmd_results() {
    local session="${1:-latest}"
    local format="${2:-summary}"
    
    if [[ "$session" == "latest" ]]; then
        session=$(ls -t "$RESULTS_DIR" | head -1)
    fi
    
    local session_dir="$RESULTS_DIR/$session"
    
    if [[ ! -d "$session_dir" ]]; then
        echo -e "${RED}❌ Session not found: $session${NC}"
        exit 1
    fi
    
    case "$format" in
        summary)
            display_results "$session_dir"
            ;;
        detailed)
            display_detailed_results "$session_dir"
            ;;
        dashboard)
            open_dashboard "$session_dir"
            ;;
        *)
            echo -e "${RED}❌ Unknown format: $format${NC}"
            exit 1
            ;;
    esac
}

cmd_threshold() {
    local agent="$1"
    local metric="$2"
    local min_value="$3"
    
    echo -e "${BLUE}⚡ Setting quality threshold${NC}"
    echo "Agent: $agent"
    echo "Metric: $metric"
    echo "Minimum: $min_value"
    
    # Save threshold
    save_threshold "$agent" "$metric" "$min_value"
}

cmd_deploy() {
    local agent_version="$1"
    local rollout="${2:-10}"
    
    IFS=':' read -r agent version <<< "$agent_version"
    
    echo -e "${BLUE}🚀 Deploying $agent:$version${NC}"
    echo "Rollout: ${rollout}%"
    
    # Validate version passes thresholds
    if ! validate_deployment "$agent" "$version"; then
        echo -e "${RED}❌ Version does not meet quality thresholds${NC}"
        exit 1
    fi
    
    # Deploy with rollout
    deploy_version "$agent" "$version" "$rollout"
}

# Helper functions
display_results() {
    local session_dir="$1"
    local results_file="$session_dir/evaluation.json"
    
    if [[ ! -f "$results_file" ]]; then
        echo -e "${RED}❌ No results found${NC}"
        return
    fi
    
    echo -e "\n${GREEN}📊 Evaluation Results${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Display metrics (simplified for bash)
    cat "$results_file" | jq -r '
        .metrics | to_entries | .[] |
        "\(.key): \(.value.score) (\(.value.status))"
    '
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Overall score
    local overall=$(cat "$results_file" | jq -r '.overall_score')
    echo -e "Overall Score: ${BLUE}$overall${NC}"
}

# Show usage
usage() {
    cat << EOF
${BLUE}Nexus Evaluation Framework${NC}

Usage: nexus eval [command] [options]

Commands:
  test AGENT:VERSION [TASKS] [--compare-to VERSION]
    Test an agent version with specified tasks
    
  create AGENT:VARIANT
    Create a new agent variant for testing
    
  compare VERSION1,VERSION2,...
    Compare multiple agent versions
    
  monitor [--agents AGENTS] [--metrics METRICS]
    Start monitoring dashboard
    
  analyze [--period PERIOD] [--agent AGENT]
    Analyze agent performance
    
  suggest AGENT [--based-on SOURCE]
    Generate improvement suggestions
    
  results [--session SESSION] [--format FORMAT]
    Display test results
    
  threshold AGENT METRIC MIN_VALUE
    Set quality threshold for deployment
    
  deploy AGENT:VERSION [--rollout PERCENTAGE]
    Deploy agent version with gradual rollout

Examples:
  nexus eval test product:v1.1 standard
  nexus eval create designer:mobile-first
  nexus eval compare product:v1.0,product:v1.1
  nexus eval monitor --agents all
  nexus eval deploy architect:v2.0 --rollout 25

EOF
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        test)
            cmd_test "$@"
            ;;
        create)
            cmd_create "$@"
            ;;
        compare)
            cmd_compare "$@"
            ;;
        monitor)
            cmd_monitor "$@"
            ;;
        analyze)
            cmd_analyze "$@"
            ;;
        suggest)
            cmd_suggest "$@"
            ;;
        results)
            cmd_results "$@"
            ;;
        threshold)
            cmd_threshold "$@"
            ;;
        deploy)
            cmd_deploy "$@"
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            echo -e "${RED}❌ Unknown command: $command${NC}"
            usage
            exit 1
            ;;
    esac
}

# Run main
main "$@"