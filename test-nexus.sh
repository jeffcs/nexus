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
        ".claude"
        ".claude/agents"
        "nexus-context"
        "nexus-patterns"
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
        "product"
        "designer"
        "architect"
        "developer"
        "technician"
    )
    
    for agent in "${agents[@]}"; do
        ((TESTS++))
        if [ -f ".claude/agents/$agent.md" ]; then
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
        if [ -f "nexus-context/$file.md" ]; then
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
    if [ -f "nexus-guide.md" ]; then
        print_pass "nexus-guide.md documentation exists"
    else
        print_fail "nexus-guide.md documentation missing"
    fi
}

# Test configuration files
test_configuration() {
    print_test "Configuration Files"
    
    ((TESTS++))
    if [ -f ".claude/settings.json" ]; then
        print_pass "Claude settings.json exists"
    else
        print_fail "Claude settings.json missing"
    fi
    
    ((TESTS++))
    if [ -f "CLAUDE.md" ]; then
        print_pass "CLAUDE.md exists"
    else
        print_fail "CLAUDE.md missing"
    fi
    
    ((TESTS++))
    if [ -f ".gitignore" ] && grep -q "\.claude/settings\.local\.json" ".gitignore"; then
        print_pass ".gitignore configured correctly"
    else
        print_fail ".gitignore not configured"
    fi
}

# Test agent content
test_agent_content() {
    print_test "Agent Content Validation"
    
    # Check if agents have proper YAML frontmatter
    agents=(
        "product"
        "designer"
        "architect"
        "developer"
        "technician"
    )
    
    for agent in "${agents[@]}"; do
        ((TESTS++))
        
        if [ -f ".claude/agents/$agent.md" ] && grep -q "^name: $agent" ".claude/agents/$agent.md"; then
            print_pass "$agent has valid frontmatter"
        else
            print_fail "$agent frontmatter missing or invalid"
        fi
    done
}

# Test pattern examples
test_patterns() {
    print_test "Pattern System"
    
    agents=(
        "product"
        "designer"
        "architect"
        "developer"
        "technician"
    )
    
    for agent in "${agents[@]}"; do
        ((TESTS++))
        if [ -f "nexus-patterns/$agent.md" ]; then
            print_pass "$agent patterns file exists"
        else
            print_fail "$agent patterns file missing"
        fi
    done
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
    
    if [ ! -d ".claude" ]; then
        echo -e "${RED}Error: .claude directory not found!${NC}"
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
    
    print_summary
}

# Run tests
main "$@"