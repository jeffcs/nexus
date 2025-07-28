#!/bin/bash
# NEXUS MCP Manager - Manages Model Context Protocol server connections

source "$(dirname "${BASH_SOURCE[0]}")/../core/common.sh"

# MCP configuration paths
MCP_USER_CONFIG="$HOME/.nexus/mcp-config.json"
MCP_PROJECT_CONFIG=".nexus/mcp-config.json"
MCP_SYSTEM_DIR="$NEXUS_ROOT/vault/mcp/servers"

# Initialize MCP configuration
init_mcp_config() {
    local config_file="$1"
    
    if [ ! -f "$config_file" ]; then
        mkdir -p "$(dirname "$config_file")"
        cat > "$config_file" << 'EOF'
{
  "servers": {
    "filesystem": {
      "enabled": false,
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "config": {
        "paths": ["./"]
      }
    },
    "github": {
      "enabled": false,
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "config": {
        "token": "${GITHUB_TOKEN}"
      }
    },
    "sequential-thinking": {
      "enabled": false,
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@smithery-ai/server-sequential-thinking"]
    },
    "web-fetch": {
      "enabled": true,
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  },
  "auth": {
    "github": {
      "type": "oauth2",
      "scope": "repo"
    }
  }
}
EOF
        echo "Created MCP configuration at $config_file"
    fi
}

# List available MCP servers
list_mcp_servers() {
    echo -e "${BLUE}Available MCP Servers:${NC}"
    echo
    
    # Check user config
    if [ -f "$MCP_USER_CONFIG" ]; then
        echo -e "${YELLOW}User Servers (~/.nexus/mcp-config.json):${NC}"
        jq -r '.servers | to_entries[] | "\(.key): \(if .value.enabled then "✓ enabled" else "✗ disabled" end)"' "$MCP_USER_CONFIG" 2>/dev/null
        echo
    fi
    
    # Check project config
    if [ -f "$MCP_PROJECT_CONFIG" ]; then
        echo -e "${YELLOW}Project Servers (.nexus/mcp-config.json):${NC}"
        jq -r '.servers | to_entries[] | "\(.key): \(if .value.enabled then "✓ enabled" else "✗ disabled" end)"' "$MCP_PROJECT_CONFIG" 2>/dev/null
        echo
    fi
    
    # List system servers
    if [ -d "$MCP_SYSTEM_DIR" ]; then
        echo -e "${YELLOW}System Servers:${NC}"
        ls -1 "$MCP_SYSTEM_DIR"/*.json 2>/dev/null | while read -r server; do
            basename "$server" .json
        done
    fi
}

# Enable/disable an MCP server
toggle_mcp_server() {
    local server_name="$1"
    local action="$2"  # enable or disable
    local scope="${3:-project}"  # user, project, or system
    
    local config_file
    case "$scope" in
        user) config_file="$MCP_USER_CONFIG" ;;
        project) config_file="$MCP_PROJECT_CONFIG" ;;
        *) echo "Invalid scope: $scope"; return 1 ;;
    esac
    
    if [ ! -f "$config_file" ]; then
        init_mcp_config "$config_file"
    fi
    
    # Update the enabled status
    local enabled_value="false"
    [ "$action" = "enable" ] && enabled_value="true"
    
    jq ".servers[\"$server_name\"].enabled = $enabled_value" "$config_file" > "$config_file.tmp" && \
    mv "$config_file.tmp" "$config_file"
    
    echo "MCP server '$server_name' ${action}d in $scope scope"
}

# Generate Claude Code compatible MCP configuration
generate_claude_config() {
    local output_file="${1:-.claude_code_settings.json}"
    
    echo -e "${BLUE}Generating Claude Code MCP configuration...${NC}"
    
    # Merge configurations from all scopes
    local merged_config="{\"mcpServers\": {}}"
    
    # Add user servers
    if [ -f "$MCP_USER_CONFIG" ]; then
        merged_config=$(echo "$merged_config" | jq --slurpfile user "$MCP_USER_CONFIG" '
            .mcpServers += ($user[0].servers | to_entries | map(select(.value.enabled)) | from_entries)
        ')
    fi
    
    # Add project servers (override user)
    if [ -f "$MCP_PROJECT_CONFIG" ]; then
        merged_config=$(echo "$merged_config" | jq --slurpfile project "$MCP_PROJECT_CONFIG" '
            .mcpServers += ($project[0].servers | to_entries | map(select(.value.enabled)) | from_entries)
        ')
    fi
    
    # Transform to Claude Code format
    local claude_config=$(echo "$merged_config" | jq '{
        mcpServers: .mcpServers | to_entries | map({
            key: .key,
            value: {
                type: .value.type,
                command: .value.command,
                args: .value.args,
                config: .value.config
            }
        }) | from_entries
    }')
    
    echo "$claude_config" | jq '.' > "$output_file"
    echo -e "${GREEN}✓ Generated Claude Code configuration at $output_file${NC}"
}

# Main command handler
case "${1:-help}" in
    init)
        init_mcp_config "${2:-$MCP_PROJECT_CONFIG}"
        ;;
    list)
        list_mcp_servers
        ;;
    enable)
        toggle_mcp_server "$2" "enable" "${3:-project}"
        ;;
    disable)
        toggle_mcp_server "$2" "disable" "${3:-project}"
        ;;
    generate)
        generate_claude_config "$2"
        ;;
    help|*)
        cat << EOF
NEXUS MCP Manager

Usage: $0 <command> [options]

Commands:
  init [config_file]      Initialize MCP configuration
  list                    List available MCP servers
  enable <server> [scope] Enable an MCP server (scope: user/project)
  disable <server> [scope] Disable an MCP server
  generate [output]       Generate Claude Code compatible config
  help                    Show this help message

Examples:
  $0 init                 # Initialize project MCP config
  $0 enable github        # Enable GitHub MCP server
  $0 generate             # Generate .claude_code_settings.json

MCP servers extend NEXUS capabilities by connecting to external
tools, databases, and services through a standardized protocol.
EOF
        ;;
esac