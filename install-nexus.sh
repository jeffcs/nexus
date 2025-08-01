#!/usr/bin/env bash

# Nexus V2 Installation Script
# Installs the Nexus agent system into a project

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
NEXUS_VERSION="2.0.0"
NEXUS_REPO="https://github.com/nexus-framework/nexus-v2"
CLAUDE_DIR=".claude"
SOURCE_ROOT="$(pwd)"

# Helper functions
print_header() {
    echo -e "\n${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository!"
        echo "Nexus V2 requires a git repository. Initialize one with:"
        echo "  git init"
        exit 1
    fi
}

# Check if Nexus is already installed
check_existing_installation() {
    if [ -d "$CLAUDE_DIR/agents" ]; then
        print_warning "Claude agents already exist!"
        read -p "Overwrite existing agents? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
}

# Create directory structure
create_directory_structure() {
    print_header "Creating Claude Directory Structure"
    
    mkdir -p "$CLAUDE_DIR/agents"
    
    print_success "Created Claude directory structure"
}

# Download or copy agent files
install_agents() {
    print_header "Installing Nexus Agents"
    
    # Get the directory where this script is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    if [ -d "$SCRIPT_DIR/agents" ]; then
        # Copy from local installation
        cp "$SCRIPT_DIR/agents/"*.md "$CLAUDE_DIR/agents/"
        print_success "Copied agents from local installation"
    else
        # Download from repository
        print_info "Downloading agents from repository..."
        
        # Download each agent
        for agent in product designer architect developer technician teacher; do
            curl -sL "$NEXUS_REPO/raw/main/agents/$agent.md" \
                -o "$CLAUDE_DIR/agents/$agent.md" || {
                print_error "Failed to download $agent agent"
                exit 1
            }
            print_success "Downloaded $agent agent"
        done
    fi
}

# Install context files
install_context_files() {
    print_header "Installing Context Files"
    
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    # Create .nexus/context directory for project context
    mkdir -p ".nexus/context"
    
    if [ -d "$SCRIPT_DIR/context" ]; then
        cp -r "$SCRIPT_DIR/context/"* ".nexus/context/"
        print_success "Copied context files from local installation"
    else
        # Download from repository
        for file in project decisions ideals; do
            curl -sL "$NEXUS_REPO/raw/main/context/$file.md" \
                -o ".nexus/context/$file.md" || {
                print_error "Failed to download $file.md"
                exit 1
            }
            print_success "Downloaded $file.md"
        done
    fi
}

# Install pattern examples
install_pattern_examples() {
    print_header "Installing Pattern Examples"
    
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    # Create .nexus/patterns directory
    mkdir -p ".nexus/patterns"
    
    if [ -d "$SCRIPT_DIR/patterns" ]; then
        # Copy pattern files
        cp -r "$SCRIPT_DIR/patterns/"* ".nexus/patterns/"
        print_success "Copied pattern examples from local installation"
    else
        # Download from repository
        for agent in product designer architect developer technician; do
            curl -sL "$NEXUS_REPO/raw/main/patterns/$agent.md" \
                -o ".nexus/patterns/$agent.md" || {
                print_warning "No patterns for $agent agent yet"
            }
        done
        print_success "Pattern system initialized"
    fi
}


# Install main documentation
install_documentation() {
    print_header "Installing Documentation"
    
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    if [ -f "$SCRIPT_DIR/nexus.md" ]; then
        cp "$SCRIPT_DIR/nexus.md" "nexus-guide.md"
        print_success "Installed Nexus documentation"
    else
        curl -sL "$NEXUS_REPO/raw/main/nexus.md" \
            -o "nexus-guide.md" || {
            print_error "Failed to download documentation"
            exit 1
        }
        print_success "Downloaded Nexus documentation"
    fi
}

# Create Claude settings file
setup_claude_settings() {
    print_header "Configuring Claude Code Settings"
    
    # Check if settings.json already exists
    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        print_info "Claude settings already exist - preserving existing configuration"
    else
        # Create new settings file
        cat > "$CLAUDE_DIR/settings.json" << 'EOF'
{
  "env": {
    "NEXUS_VERSION": "2.0"
  }
}
EOF
        print_success "Created Claude settings file"
    fi
    
    # Create .gitignore for local settings
    if [ ! -f "$CLAUDE_DIR/.gitignore" ]; then
        echo "settings.local.json" > "$CLAUDE_DIR/.gitignore"
        print_success "Created .claude/.gitignore"
    fi
}

# Create CLAUDE.md if it doesn't exist
setup_claude_md() {
    if [ ! -f "CLAUDE.md" ]; then
        print_info "Creating CLAUDE.md for project instructions"
        cat > "CLAUDE.md" << 'EOF'
# Project Instructions for Claude Code

## Nexus V2 Integration

This project uses the Nexus V2 agent system. The specialized agents are available as subagents:

- **product**: Product strategy, research, and validation
- **designer**: UI/UX design and user experience
- **architect**: System design and technical architecture
- **developer**: Implementation and coding
- **technician**: Debugging, DevOps, and operations
- **teacher**: Capture and apply new patterns to agents

Agents are defined in `.claude/agents/` and will be automatically available in Claude Code.

## Usage

The agents will activate automatically based on your requests. Examples:
- "Research best practices for authentication"
- "Design a user profile page"
- "Architect a real-time messaging system"
- "Implement the login feature"
- "Debug the slow API response"
- "Teach product agent to use tldraw for mockups"

## Project Context

Project-specific context is maintained in:
- `.nexus/context/` - Project understanding and decisions
- `.nexus/patterns/` - Reusable patterns for each agent (updated by teacher)

Refer to `nexus-guide.md` for detailed usage instructions.

## Project-Specific Instructions

<!-- Add your project-specific instructions here -->
EOF
        print_success "Created CLAUDE.md"
    fi
}

# Install evaluation system
install_evaluation_system() {
    print_header "Installing Evaluation System"
    
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    # Create .nexus/evaluation directory
    mkdir -p ".nexus/evaluation"
    
    if [ -d "$SCRIPT_DIR/evaluation" ]; then
        # Copy evaluation system files
        cp -r "$SCRIPT_DIR/evaluation/"* ".nexus/evaluation/"
        chmod +x ".nexus/evaluation/"*.sh
        chmod +x ".nexus/evaluation/lib/"*.sh
        print_success "Installed evaluation system"
    else
        print_info "Evaluation system not available in this version"
    fi
}

# Update .gitignore
update_gitignore() {
    print_header "Updating .gitignore"
    
    if [ ! -f ".gitignore" ]; then
        touch .gitignore
    fi
    
    # Check if Claude local settings are already ignored
    if ! grep -q "\.claude/settings\.local\.json" ".gitignore"; then
        echo "" >> .gitignore
        echo "# Claude Code local settings" >> .gitignore
        echo ".claude/settings.local.json" >> .gitignore
        print_success "Updated .gitignore"
    else
        print_info ".gitignore already configured"
    fi
    
    # Add .nexus directory to gitignore (it's a destination)
    if ! grep -q "^\.nexus/$" ".gitignore"; then
        echo "" >> .gitignore
        echo "# Nexus runtime data (patterns and context are user-specific)" >> .gitignore
        echo ".nexus/" >> .gitignore
        print_success "Added .nexus/ to .gitignore"
    fi
    
    # Add .claude/agents to gitignore (it's a destination)
    if ! grep -q "^\.claude/agents/$" ".gitignore"; then
        echo ".claude/agents/" >> .gitignore
        print_success "Added .claude/agents/ to .gitignore"
    fi
}

# Display next steps
show_next_steps() {
    print_header "Installation Complete! 🎉"
    
    echo "Nexus V2 has been successfully installed in your project."
    echo ""
    echo "Next steps:"
    echo "1. Restart Claude Code to load the new agents"
    echo "2. Review the agents in ${BLUE}.claude/agents/${NC}"
    echo "3. Read the usage guide in ${BLUE}nexus-guide.md${NC}"
    echo "4. Customize ${BLUE}.nexus/context/ideals.md${NC} for your project"
    echo "5. Start using agents with natural language:"
    echo ""
    echo "   ${GREEN}Examples:${NC}"
    echo "   - \"Research user authentication best practices\""
    echo "   - \"Design a user profile page\""
    echo "   - \"How should we architect the payment system?\""
    echo "   - \"Implement the shopping cart feature\""
    echo "   - \"Debug the slow API response\""
    echo ""
    echo "For more information, see ${BLUE}nexus-guide.md${NC}"
    echo ""
    print_success "Happy coding with Nexus V2! 🚀"
}

# Main installation flow
main() {
    print_header "Nexus V2 Installation"
    echo "Installing Nexus V2 - Intelligent Agent System"
    echo "Version: $NEXUS_VERSION"
    echo ""
    
    # Pre-flight checks
    check_git_repo
    check_existing_installation
    
    # Installation steps
    create_directory_structure
    install_agents
    install_context_files
    install_pattern_examples
    install_documentation
    install_evaluation_system
    setup_claude_settings
    setup_claude_md
    update_gitignore
    
    # Done!
    show_next_steps
}

# Run main function
main "$@"