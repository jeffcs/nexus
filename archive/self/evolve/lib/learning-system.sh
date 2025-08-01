#!/bin/bash
# NEXUS Learning System - Captures and analyzes evolution insights

# Set NEXUS_ROOT if not already set
if [ -z "$NEXUS_ROOT" ]; then
    NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
fi
LEARNINGS_DIR="$NEXUS_ROOT/self/evolve/evolutions"
CURRENT_VERSION=$(jq -r '.version // "4.0.0"' "$NEXUS_ROOT/self/dna/version.json" 2>/dev/null || echo "4.0.0")

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Ensure learnings directory exists
mkdir -p "$LEARNINGS_DIR"

# Analyze git history since last evolution
analyze_git_history() {
    local last_evolution_tag=$(git tag -l "v*" --sort=-version:refname | head -n 1)
    local current_branch=$(git branch --show-current)
    
    echo -e "${BLUE}📊 Analyzing changes since $last_evolution_tag...${NC}"
    
    # Get commit messages
    local commits=$(git log $last_evolution_tag..HEAD --oneline 2>/dev/null || git log --oneline -10)
    
    # Get file changes
    local changes=$(git diff --stat $last_evolution_tag..HEAD 2>/dev/null || git diff --stat HEAD~10..HEAD)
    
    # Extract patterns
    local patterns=""
    if echo "$commits" | grep -q "✨"; then
        patterns="${patterns}- New features added\n"
    fi
    if echo "$commits" | grep -q "🔧"; then
        patterns="${patterns}- Configuration improvements\n"
    fi
    if echo "$commits" | grep -q "📚"; then
        patterns="${patterns}- Documentation updates\n"
    fi
    if echo "$commits" | grep -q "🐛"; then
        patterns="${patterns}- Bug fixes applied\n"
    fi
    
    # Create learning summary
    cat > "$LEARNINGS_DIR/git-analysis-$(date +%Y%m%d-%H%M%S).md" << EOF
# Git History Analysis
Generated: $(date)
Since: $last_evolution_tag

## Commit Summary
$commits

## Changed Files
$changes

## Patterns Detected
$patterns

## Key Changes
EOF
    
    # Analyze specific important files
    if git diff $last_evolution_tag..HEAD --name-only | grep -q "evolve.sh"; then
        echo "- Evolution system modified" >> "$LEARNINGS_DIR/git-analysis-$(date +%Y%m%d-%H%M%S).md"
    fi
    if git diff $last_evolution_tag..HEAD --name-only | grep -q "claude/"; then
        echo "- Claude integration updated" >> "$LEARNINGS_DIR/git-analysis-$(date +%Y%m%d-%H%M%S).md"
    fi
    if git diff $last_evolution_tag..HEAD --name-only | grep -q "modules/agents/"; then
        echo "- Agent capabilities enhanced" >> "$LEARNINGS_DIR/git-analysis-$(date +%Y%m%d-%H%M%S).md"
    fi
}

# Extract learnings from recent changes
extract_learnings() {
    local learnings_file="$LEARNINGS_DIR/evolution-${CURRENT_VERSION}-learnings.md"
    
    echo -e "${BLUE}🧠 Extracting learnings...${NC}"
    
    cat > "$learnings_file" << EOF
# Evolution Learnings - v${CURRENT_VERSION}
Generated: $(date)

## What We Learned

### Technical Insights
EOF
    
    # Analyze tool usage patterns
    if [ -f "$NEXUS_ROOT/self/metrics/tool-usage.jsonl" ]; then
        echo -e "\n### Tool Usage Patterns" >> "$learnings_file"
        jq -s 'group_by(.tool) | map({tool: .[0].tool, count: length}) | sort_by(.count) | reverse' \
            "$NEXUS_ROOT/self/metrics/tool-usage.jsonl" >> "$learnings_file" 2>/dev/null || echo "No tool metrics available" >> "$learnings_file"
    fi
    
    # Check for new patterns
    if [ -d "$NEXUS_ROOT/vault/patterns" ]; then
        echo -e "\n### New Patterns Created" >> "$learnings_file"
        find "$NEXUS_ROOT/vault/patterns" -type f -newer "$NEXUS_ROOT/self/dna/version.json" -name "*.md" | \
            while read -r pattern; do
                echo "- $(basename "$pattern" .md)" >> "$learnings_file"
            done
    fi
    
    # Check for agent enhancements
    echo -e "\n### Agent Enhancements" >> "$learnings_file"
    find "$NEXUS_ROOT/modules/agents" -name "*.yaml" -newer "$NEXUS_ROOT/self/dna/version.json" | \
        while read -r agent; do
            echo "- $(basename "$(dirname "$agent")"): Updated capabilities" >> "$learnings_file"
        done
    
    # Add decisions and trade-offs
    echo -e "\n## Decisions & Trade-offs" >> "$learnings_file"
    echo "- Command structure migrated from /nexus: to /nexus/ for consistency" >> "$learnings_file"
    echo "- Hooks made self-contained to avoid path resolution issues" >> "$learnings_file"
    echo "- Added version checking to banner for dynamic updates" >> "$learnings_file"
    
    echo "$learnings_file"
}

# Generate proposed changes based on learnings
generate_proposals() {
    local guidance="$1"
    local proposals_file="$LEARNINGS_DIR/evolution-proposals-$(date +%Y%m%d-%H%M%S).md"
    
    echo -e "${BLUE}💡 Generating evolution proposals...${NC}"
    
    cat > "$proposals_file" << EOF
# Evolution Proposals
Generated: $(date)
Current Version: ${CURRENT_VERSION}

## User Guidance
$guidance

## Proposed Changes Based on Analysis

### High Priority
EOF
    
    # Analyze current pain points
    if grep -q "error\|fail\|fix" "$LEARNINGS_DIR"/git-analysis-*.md 2>/dev/null; then
        echo "- Address recent error patterns and stability issues" >> "$proposals_file"
    fi
    
    # Check for missing features
    if [ ! -f "$NEXUS_ROOT/modules/commands/nexus-test.sh" ]; then
        echo "- Add comprehensive testing framework" >> "$proposals_file"
    fi
    
    if [ ! -d "$NEXUS_ROOT/self/analytics" ]; then
        echo "- Implement analytics and metrics dashboard" >> "$proposals_file"
    fi
    
    echo -e "\n### Medium Priority" >> "$proposals_file"
    echo "- Enhance agent collaboration patterns" >> "$proposals_file"
    echo "- Add more factory templates based on usage" >> "$proposals_file"
    echo "- Improve error handling and recovery" >> "$proposals_file"
    
    echo -e "\n### Based on Mission Alignment" >> "$proposals_file"
    echo "- Accelerate SaaS product bootstrapping" >> "$proposals_file"
    echo "- Enhance multi-project management capabilities" >> "$proposals_file"
    echo "- Strengthen enterprise-grade patterns" >> "$proposals_file"
    
    echo "$proposals_file"
}

# Show proposals and get user feedback
show_proposals_with_validation() {
    local proposals_file="$1"
    local guidance="$2"
    
    echo -e "\n${YELLOW}📋 PROPOSED EVOLUTION CHANGES${NC}"
    echo "================================"
    cat "$proposals_file"
    echo "================================"
    
    echo -e "\n${YELLOW}Press ENTER to proceed, ESC to add more guidance, or Ctrl+C to cancel${NC}"
    
    # Read single character with timeout
    read -rsn1 -t 30 key
    
    if [[ $key == $'\x1b' ]]; then
        echo -e "\n${BLUE}📝 Additional guidance (press Ctrl+D when done):${NC}"
        additional_guidance=$(cat)
        guidance="${guidance}\n\nAdditional Guidance:\n${additional_guidance}"
        
        # Regenerate proposals with new guidance
        proposals_file=$(generate_proposals "$guidance")
        show_proposals_with_validation "$proposals_file" "$guidance"
    elif [[ $key == "" ]]; then
        echo -e "\n${GREEN}✅ Proceeding with evolution...${NC}"
    else
        echo -e "\n${YELLOW}⏸️  Evolution paused${NC}"
        exit 0
    fi
    
    echo "$guidance" > "$LEARNINGS_DIR/evolution-guidance-final.md"
}

# Main learning capture function
capture_learnings() {
    local guidance="${1:-Automatic evolution based on learnings}"
    
    echo -e "${BLUE}🧬 NEXUS Learning System${NC}"
    echo "========================"
    
    # Analyze git history
    analyze_git_history
    
    # Extract learnings
    local learnings_file=$(extract_learnings)
    
    # Generate proposals
    local proposals_file=$(generate_proposals "$guidance")
    
    # Show and validate proposals
    show_proposals_with_validation "$proposals_file" "$guidance"
    
    # Save combined insights
    cat > "$LEARNINGS_DIR/evolution-${CURRENT_VERSION}-complete.md" << EOF
# Evolution Intelligence Report
Version: ${CURRENT_VERSION}
Date: $(date)

## Learnings
$(cat "$learnings_file")

## Proposals
$(cat "$proposals_file")

## Final Guidance
$(cat "$LEARNINGS_DIR/evolution-guidance-final.md" 2>/dev/null || echo "$guidance")

## Mission Alignment Check
- [ ] Accelerates product development
- [ ] Increases system intelligence  
- [ ] Reduces repetitive work
- [ ] Enhances agent capabilities
- [ ] Strengthens feedback loops

---
*Generated by NEXUS Learning System*
EOF
    
    echo -e "\n${GREEN}✅ Learning capture complete!${NC}"
    echo "   Report: $LEARNINGS_DIR/evolution-${CURRENT_VERSION}-complete.md"
}

# Export functions for use in evolve.sh
export -f analyze_git_history
export -f extract_learnings
export -f generate_proposals
export -f show_proposals_with_validation
export -f capture_learnings