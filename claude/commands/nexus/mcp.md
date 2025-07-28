---
description: Manage Model Context Protocol servers
allowed-tools: [Bash, Edit, Write, Read, Glob, Grep, LS]
argument-hint: <init|list|enable|disable|status> [server-name]
---

You are managing NEXUS's Model Context Protocol (MCP) integration.
MCP extends NEXUS capabilities by connecting to external tools and services.

Task: $ARGUMENTS

@nexus/modules/mcp/mcp-manager.sh
@nexus/modules/mcp/mcp-integration.sh
@nexus/modules/mcp/README.md

Execute MCP management based on the arguments:

1. **init**: Initialize MCP for current project
   - Create configuration files
   - Enable recommended servers
   - Generate Claude Code settings

2. **list**: Show available MCP servers
   - Display all configured servers
   - Show enabled/disabled status
   - List available tools

3. **enable <server>**: Enable an MCP server
   - Activate the specified server
   - Update configuration
   - Regenerate Claude Code settings

4. **disable <server>**: Disable an MCP server
   - Deactivate the specified server
   - Update configuration
   - Regenerate Claude Code settings

5. **status**: Show current MCP status
   - Check MCP availability
   - List enabled servers
   - Show active connections

After any configuration change, remind the user to restart
Claude Code for the changes to take effect.

Available servers:
- sequential-thinking: Enhanced reasoning
- github: Repository management
- filesystem: File operations
- web-fetch: Web content retrieval

Remember: MCP servers extend NEXUS without modifying core functionality.