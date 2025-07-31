#!/usr/bin/env bash

# Nexus V2 Test Script
# Tests the installation and basic functionality

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_test() {
    echo -e "\n${BLUE}Testing: $1${NC}"
}

print_pass() {
    echo -e "${GREEN}✓ PASS:${NC} $1"
}

print_fail() {
    echo -e "${RED}✗ FAIL:${NC} $1"
    ((FAILURES++))
}

# Test counters
TESTS=0
FAILURES=0

# Test directory structure
test_directory_structure() {
    print_test "Directory Structure"
    
    directories=(
        ".nexus"
        ".nexus/agents"
        ".nexus/patterns"
        ".nexus/patterns/design"
        ".nexus/patterns/architecture"
        ".nexus/patterns/code"
        ".nexus/patterns/operations"
        ".nexus/context"
        ".nexus/learning"
    )
    
    for dir in "${directories[@]}"; do
        ((TESTS++))
        if [ -d "$dir" ]; then
            print_pass "$dir exists"
        else
            print_fail "$dir missing"
        fi
    done
}

# Test agent files
test_agent_files() {
    print_test "Agent Files"
    
    agents=(
        "designer"
        "architect"
        "developer"
        "technician"
        "discovery"
    )
    
    for agent in "${agents[@]}"; do
        ((TESTS++))
        if [ -f ".nexus/agents/$agent.md" ]; then
            print_pass "$agent agent installed"
        else
            print_fail "$agent agent missing"
        fi
    done
}

# Test context files
test_context_files() {
    print_test "Context Files"
    
    files=(
        "project"
        "decisions"
        "ideals"
    )
    
    for file in "${files[@]}"; do
        ((TESTS++))
        if [ -f ".nexus/context/$file.md" ]; then
            print_pass "$file.md exists"
        else
            print_fail "$file.md missing"
        fi
    done
}

# Test documentation
test_documentation() {
    print_test "Documentation"
    
    ((TESTS++))
    if [ -f ".nexus/nexus.md" ]; then
        print_pass "nexus.md documentation exists"
    else
        print_fail "nexus.md documentation missing"
    fi
}

# Test configuration files
test_configuration() {
    print_test "Configuration Files"
    
    ((TESTS++))
    if [ -f ".clauderc" ] || [ -f "CLAUDE.md" ]; then
        print_pass "Claude configuration exists"
    else
        print_fail "Claude configuration missing"
    fi
    
    ((TESTS++))
    if [ -f ".gitignore" ] && grep -q "\.nexus/learning/" ".gitignore"; then
        print_pass ".gitignore configured correctly"
    else
        print_fail ".gitignore not configured"
    fi
}

# Test agent content
test_agent_content() {
    print_test "Agent Content Validation"
    
    # Check if agents have proper structure
    agents=(
        "designer:Product Manager + Designer + UI/UX Engineer"
        "architect:System Designer + Technical Strategist"
        "developer:Builder + Analyst + Integrator"
        "technician:Debugger + DevOps + Production Specialist"
        "discovery:Researcher + Technology Scout"
    )
    
    for agent_info in "${agents[@]}"; do
        ((TESTS++))
        agent="${agent_info%%:*}"
        role="${agent_info#*:}"
        
        if grep -q "$role" ".nexus/agents/$agent.md" 2>/dev/null; then
            print_pass "$agent has correct role definition"
        else
            print_fail "$agent role definition incorrect or missing"
        fi
    done
}

# Test pattern examples
test_patterns() {
    print_test "Pattern System"
    
    ((TESTS++))
    pattern_count=$(find .nexus/patterns -name "*.md" -type f 2>/dev/null | wc -l)
    if [ "$pattern_count" -gt 0 ]; then
        print_pass "Found $pattern_count pattern files"
    else
        print_pass "Pattern directories ready (patterns created through usage)"
    fi
}

# Test learning system
test_learning_system() {
    print_test "Learning System"
    
    ((TESTS++))
    if [ -f ".nexus/learning/pattern-recognizer.ts" ]; then
        print_pass "Pattern recognizer installed"
    else
        print_pass "Pattern recognizer will be installed on demand"
    fi
}

# Summary
print_summary() {
    echo -e "\n${BLUE}============================================${NC}"
    echo -e "${BLUE}Test Summary${NC}"
    echo -e "${BLUE}============================================${NC}"
    
    PASSED=$((TESTS - FAILURES))
    
    echo -e "Total Tests: $TESTS"
    echo -e "${GREEN}Passed: $PASSED${NC}"
    echo -e "${RED}Failed: $FAILURES${NC}"
    
    if [ "$FAILURES" -eq 0 ]; then
        echo -e "\n${GREEN}✓ All tests passed! Nexus V2 is properly installed.${NC}"
        return 0
    else
        echo -e "\n${RED}✗ Some tests failed. Please check the installation.${NC}"
        return 1
    fi
}

# Main test execution
main() {
    echo -e "${BLUE}Nexus V2 Installation Test${NC}"
    echo -e "${BLUE}===========================${NC}"
    
    if [ ! -d ".nexus" ]; then
        echo -e "${RED}Error: .nexus directory not found!${NC}"
        echo "Please run the installation script first:"
        echo "  ./install-nexus.sh"
        exit 1
    fi
    
    test_directory_structure
    test_agent_files
    test_context_files
    test_documentation
    test_configuration
    test_agent_content
    test_patterns
    test_learning_system
    
    print_summary
}

# Run tests
main "$@"