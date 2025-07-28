#!/bin/bash
# NEXUS Init Command - Initialize or update NEXUS in a project

# Find the NEXUS source directory
NEXUS_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROJECT_DIR="$(pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse arguments
FORCE=false
MODE="standard"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --force) FORCE=true ;;
        --minimal) MODE="minimal" ;;
        --full) MODE="full" ;;
        --help|-h) 
            echo "Usage: nexus-init [options]"
            echo ""
            echo "Options:"
            echo "  --force     Force reinstall even if up to date"
            echo "  --minimal   Install only core components"
            echo "  --full      Install all components including examples"
            echo "  --help      Show this help message"
            exit 0
            ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Show banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║          NEXUS INIT v4.0.0            ║"
echo "║   Project Initialization System       ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Check if we're in the NEXUS source directory
if [ "$PROJECT_DIR" = "$NEXUS_SOURCE" ]; then
    echo -e "${RED}❌ Cannot initialize NEXUS in its own source directory${NC}"
    echo "   Please run this command from your project directory"
    exit 1
fi

# Check for existing NEXUS installation
if [ -d ".nexus" ] && [ "$FORCE" != "true" ]; then
    echo -e "${YELLOW}⚠️  NEXUS is already installed in this project${NC}"
    
    # Check version
    if [ -f ".nexus/version.json" ]; then
        installed_version=$(jq -r '.version // "unknown"' .nexus/version.json 2>/dev/null || echo "unknown")
        current_version=$(jq -r '.version // "4.0.0"' "$NEXUS_SOURCE/self/dna/version.json" 2>/dev/null || echo "4.0.0")
        
        echo "   Installed version: $installed_version"
        echo "   Current version: $current_version"
        
        if [ "$installed_version" != "$current_version" ]; then
            echo ""
            echo -e "${YELLOW}📦 An update is available!${NC}"
            read -p "   Would you like to update? (y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "   Update cancelled"
                exit 0
            fi
        else
            echo -e "${GREEN}✅ Your NEXUS installation is up to date${NC}"
            exit 0
        fi
    fi
fi

# Initialize NEXUS
echo -e "${BLUE}🚀 Initializing NEXUS in $(basename "$PROJECT_DIR")...${NC}"
echo ""

# Create .nexus directory structure
echo "📁 Creating directory structure..."
mkdir -p .nexus/{agents,commands,patterns,specs,config}

# Copy version info
echo "📋 Installing version info..."
cp "$NEXUS_SOURCE/self/dna/version.json" .nexus/

# Install core components based on mode
case "$MODE" in
    minimal)
        echo "📦 Installing minimal components..."
        # Core agents only
        cp -r "$NEXUS_SOURCE/modules/agents/genesis" .nexus/agents/
        cp -r "$NEXUS_SOURCE/modules/agents/architect" .nexus/agents/
        cp -r "$NEXUS_SOURCE/modules/agents/forge" .nexus/agents/
        
        # Essential commands
        mkdir -p .nexus/commands
        cp "$NEXUS_SOURCE/modules/commands/nexus-spec.sh" .nexus/commands/
        cp "$NEXUS_SOURCE/modules/commands/nexus-help.sh" .nexus/commands/
        ;;
        
    full)
        echo "📦 Installing all components..."
        # All agents
        cp -r "$NEXUS_SOURCE/modules/agents/"* .nexus/agents/
        
        # All commands
        cp -r "$NEXUS_SOURCE/modules/commands/"* .nexus/commands/
        
        # Factory components
        mkdir -p .nexus/factory/{seeds,stacks}
        cp -r "$NEXUS_SOURCE/factory/seeds/"* .nexus/factory/seeds/
        cp -r "$NEXUS_SOURCE/factory/stacks/"* .nexus/factory/stacks/
        
        # Example patterns
        cp -r "$NEXUS_SOURCE/vault/patterns/"* .nexus/patterns/
        ;;
        
    standard|*)
        echo "📦 Installing standard components..."
        # All agents
        cp -r "$NEXUS_SOURCE/modules/agents/"* .nexus/agents/
        
        # Essential commands
        cp "$NEXUS_SOURCE/modules/commands/nexus-spec.sh" .nexus/commands/
        cp "$NEXUS_SOURCE/modules/commands/nexus-help.sh" .nexus/commands/
        cp "$NEXUS_SOURCE/modules/commands/nexus-init.sh" .nexus/commands/
        
        # Basic factory components
        mkdir -p .nexus/factory/{seeds,stacks}
        cp -r "$NEXUS_SOURCE/factory/seeds/microservice" .nexus/factory/seeds/
        cp -r "$NEXUS_SOURCE/factory/stacks/javascript-fullstack" .nexus/factory/stacks/
        ;;
esac

# Create project configuration
echo "⚙️  Creating project configuration..."
cat > .nexus/config/project.yaml << EOF
# NEXUS Project Configuration
name: $(basename "$PROJECT_DIR")
nexus_version: $(jq -r '.version // "4.0.0"' "$NEXUS_SOURCE/self/dna/version.json")
initialized: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
mode: $MODE

# Project-specific agent settings
agents:
  enabled: all
  custom_prompts: {}

# Integration settings
integrations:
  claude_code: true
  agent_os: false
EOF

# Create .nexus-project marker
touch .nexus-project

# Create local commands directory for project-specific commands
mkdir -p .nexus/commands/local

# Create a basic README
cat > .nexus/README.md << EOF
# NEXUS Project Integration

This project is enhanced with NEXUS - Neural Execution & eXperimentation Unified System.

## Available Commands

- \`/nexus:help\` - Show available commands
- \`/nexus:spec\` - Create a new specification
- \`/nexus:genesis\` - Bootstrap new components
- \`/nexus:architect\` - Design system architecture
- \`/nexus:forge\` - Generate code from specs

## Project Structure

\`\`\`
.nexus/
├── agents/      # AI agent configurations
├── commands/    # Available commands
├── patterns/    # Reusable patterns
├── specs/       # Project specifications
└── config/      # Project configuration
\`\`\`

## Customization

You can customize NEXUS for your project by:
1. Adding custom agents in \`.nexus/agents/\`
2. Creating project commands in \`.nexus/commands/local/\`
3. Defining patterns in \`.nexus/patterns/\`
EOF

# Add to .gitignore if it exists
if [ -f .gitignore ]; then
    if ! grep -q "^.nexus-project$" .gitignore; then
        echo "" >> .gitignore
        echo "# NEXUS" >> .gitignore
        echo ".nexus-project" >> .gitignore
        echo ".nexus/specs/*/tasks.md" >> .gitignore
    fi
fi

echo ""
echo -e "${GREEN}✅ NEXUS successfully initialized!${NC}"
echo ""
echo "📚 Next steps:"
echo "   1. Review .nexus/README.md for usage"
echo "   2. Try /nexus:help to see available commands"
echo "   3. Use /nexus:spec to create your first specification"
echo ""
echo "🚀 Happy building with NEXUS!"