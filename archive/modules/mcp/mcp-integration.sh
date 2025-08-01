#!/bin/bash
# NEXUS MCP Integration - Hooks MCP servers into NEXUS command system

source "$(dirname "${BASH_SOURCE[0]}")/../core/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/mcp-manager.sh"

# Check if MCP is available in Claude Code
check_mcp_availability() {
    # Check for .claude_code_settings.json or environment indicators
    if [ -f ".claude_code_settings.json" ] || [ -f "$HOME/.claude_code_settings.json" ]; then
        return 0
    fi
    return 1
}

# Initialize MCP for current project
init_mcp_integration() {
    echo -e "${BLUE}Initializing MCP integration for NEXUS...${NC}"
    
    # Create MCP config if not exists
    if [ ! -f "$MCP_PROJECT_CONFIG" ]; then
        init_mcp_config "$MCP_PROJECT_CONFIG"
    fi
    
    # Enable recommended servers for NEXUS
    local recommended_servers=(
        "sequential-thinking"
        "web-fetch"
    )
    
    for server in "${recommended_servers[@]}"; do
        toggle_mcp_server "$server" "enable" "project"
    done
    
    # Generate Claude Code config
    generate_claude_config
    
    echo -e "${GREEN}✓ MCP integration initialized${NC}"
    echo -e "${YELLOW}Recommended: Restart Claude Code to load MCP servers${NC}"
}

# List available MCP tools
list_mcp_tools() {
    echo -e "${BLUE}Available MCP Tools:${NC}"
    echo
    
    # Check enabled servers
    local enabled_servers=()
    if [ -f "$MCP_PROJECT_CONFIG" ]; then
        enabled_servers+=($(jq -r '.servers | to_entries[] | select(.value.enabled) | .key' "$MCP_PROJECT_CONFIG" 2>/dev/null))
    fi
    if [ -f "$MCP_USER_CONFIG" ]; then
        enabled_servers+=($(jq -r '.servers | to_entries[] | select(.value.enabled) | .key' "$MCP_USER_CONFIG" 2>/dev/null))
    fi
    
    # Remove duplicates
    enabled_servers=($(echo "${enabled_servers[@]}" | tr ' ' '\n' | sort -u))
    
    if [ ${#enabled_servers[@]} -eq 0 ]; then
        echo "No MCP servers enabled. Run: nexus mcp init"
        return
    fi
    
    # Show tools for each enabled server
    for server in "${enabled_servers[@]}"; do
        echo -e "${YELLOW}$server:${NC}"
        case "$server" in
            sequential-thinking)
                echo "  - think_sequential: Step-by-step reasoning"
                echo "  - break_down: Decompose complex problems"
                ;;
            github)
                echo "  - github_search: Search code across repos"
                echo "  - github_pr: Manage pull requests"
                echo "  - github_issue: Manage issues"
                ;;
            filesystem)
                echo "  - fs_read: Read files with MCP"
                echo "  - fs_write: Write files with MCP"
                echo "  - fs_list: List directory contents"
                ;;
            web-fetch)
                echo "  - web_fetch: Retrieve web content"
                echo "  - web_search: Search the web"
                ;;
        esac
        echo
    done
}

# Suggest MCP usage for current context
suggest_mcp_usage() {
    local context="$1"
    
    echo -e "${BLUE}MCP Enhancement Suggestions:${NC}"
    echo
    
    case "$context" in
        *debug*|*error*|*problem*)
            echo "• Enable 'sequential-thinking' for step-by-step debugging"
            echo "  Command: nexus mcp enable sequential-thinking"
            ;;
        *github*|*pr*|*pull*)
            echo "• Enable 'github' for repository operations"
            echo "  Command: nexus mcp enable github"
            ;;
        *web*|*search*|*research*)
            echo "• Enable 'web-fetch' for web content retrieval"
            echo "  Command: nexus mcp enable web-fetch"
            ;;
        *file*|*directory*)
            echo "• Enable 'filesystem' for enhanced file operations"
            echo "  Command: nexus mcp enable filesystem"
            ;;
    esac
}

# Export functions for use in NEXUS commands
export -f check_mcp_availability
export -f init_mcp_integration
export -f list_mcp_tools
export -f suggest_mcp_usage