# NEXUS MCP Integration

The Model Context Protocol (MCP) integration extends NEXUS capabilities by connecting to external tools, databases, and services through a standardized protocol.

## Architecture

```
NEXUS Core
    ├── MCP Manager
    │   ├── Server Registry
    │   ├── Connection Pool
    │   └── Auth Manager
    ├── MCP Servers
    │   ├── Filesystem (local file operations)
    │   ├── GitHub (repository management)
    │   ├── Sequential Thinking (enhanced reasoning)
    │   ├── Web Fetch (content retrieval)
    │   └── Database Connectors
    └── Integration Layer
        ├── Resource Access (@mentions)
        ├── Tool Extensions
        └── Slash Commands
```

## Benefits

1. **Extended Capabilities**: Access databases, APIs, and external tools
2. **Dynamic Integration**: Connect new services without modifying core
3. **Secure Access**: OAuth 2.0 and scoped permissions
4. **Real-time Data**: Live connections to external systems

## Configuration

MCP servers are configured at three levels:
- **User**: ~/.nexus/mcp-config.json
- **Project**: .nexus/mcp-config.json
- **System**: /vault/mcp/servers/

## Security

- Only trusted MCP servers should be connected
- Each server runs with minimal required permissions
- Authentication tokens are stored securely
- Connections are isolated per project