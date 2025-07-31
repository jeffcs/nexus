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
NEXUS_DIR=".nexus"

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
    if [ -d "$NEXUS_DIR" ]; then
        print_warning "Nexus directory already exists!"
        read -p "Overwrite existing installation? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
        rm -rf "$NEXUS_DIR"
    fi
}

# Create directory structure
create_directory_structure() {
    print_header "Creating Nexus Directory Structure"
    
    mkdir -p "$NEXUS_DIR"/{agents,patterns,context,learning}
    mkdir -p "$NEXUS_DIR"/patterns/{design,architecture,code,operations,shared}
    
    print_success "Created directory structure"
}

# Download or copy agent files
install_agents() {
    print_header "Installing Nexus Agents"
    
    # Get the directory where this script is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    SOURCE_DIR="$SCRIPT_DIR/.nexus"
    
    if [ -d "$SOURCE_DIR/agents" ]; then
        # Copy from local installation
        cp -r "$SOURCE_DIR/agents/"* "$NEXUS_DIR/agents/"
        print_success "Copied agents from local installation"
    else
        # Download from repository
        print_info "Downloading agents from repository..."
        
        # Download each agent
        for agent in designer architect developer technician discovery; do
            curl -sL "$NEXUS_REPO/raw/main/.nexus/agents/$agent.md" \
                -o "$NEXUS_DIR/agents/$agent.md" || {
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
    SOURCE_DIR="$SCRIPT_DIR/.nexus"
    
    if [ -d "$SOURCE_DIR/context" ]; then
        cp -r "$SOURCE_DIR/context/"* "$NEXUS_DIR/context/"
        print_success "Copied context files from local installation"
    else
        # Download from repository
        for file in project decisions ideals; do
            curl -sL "$NEXUS_REPO/raw/main/.nexus/context/$file.md" \
                -o "$NEXUS_DIR/context/$file.md" || {
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
    SOURCE_DIR="$SCRIPT_DIR/.nexus"
    
    if [ -d "$SOURCE_DIR/patterns" ]; then
        # Copy any existing patterns
        find "$SOURCE_DIR/patterns" -name "*.md" -type f | while read -r file; do
            rel_path="${file#$SOURCE_DIR/patterns/}"
            mkdir -p "$NEXUS_DIR/patterns/$(dirname "$rel_path")"
            cp "$file" "$NEXUS_DIR/patterns/$rel_path"
        done
        print_success "Copied pattern examples from local installation"
    else
        print_info "No pattern examples to install (patterns will be created through usage)"
    fi
}

# Install learning system
install_learning_system() {
    print_header "Installing Learning System"
    
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    SOURCE_DIR="$SCRIPT_DIR/.nexus"
    
    if [ -f "$SOURCE_DIR/learning/pattern-recognizer.ts" ]; then
        cp "$SOURCE_DIR/learning/pattern-recognizer.ts" "$NEXUS_DIR/learning/"
        print_success "Installed pattern recognition system"
    else
        print_info "Pattern recognizer will be downloaded on first use"
    fi
}

# Install main documentation
install_documentation() {
    print_header "Installing Documentation"
    
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    SOURCE_DIR="$SCRIPT_DIR/.nexus"
    
    if [ -f "$SOURCE_DIR/nexus.md" ]; then
        cp "$SOURCE_DIR/nexus.md" "$NEXUS_DIR/"
        print_success "Installed Nexus documentation"
    else
        curl -sL "$NEXUS_REPO/raw/main/.nexus/nexus.md" \
            -o "$NEXUS_DIR/nexus.md" || {
            print_error "Failed to download documentation"
            exit 1
        }
        print_success "Downloaded Nexus documentation"
    fi
}

# Create or update .clauderc file
setup_claude_config() {
    print_header "Configuring Claude Code"
    
    CLAUDE_CONFIG=".clauderc"
    
    if [ -f "$CLAUDE_CONFIG" ]; then
        # Check if Nexus is already configured
        if grep -q "nexus/agents" "$CLAUDE_CONFIG"; then
            print_info "Claude Code already configured for Nexus"
        else
            print_warning "Updating existing .clauderc file"
            # Add Nexus configuration
            echo "" >> "$CLAUDE_CONFIG"
            echo "# Nexus V2 Agent System" >> "$CLAUDE_CONFIG"
            echo "include .nexus/agents/*.md" >> "$CLAUDE_CONFIG"
            echo "include .nexus/context/*.md" >> "$CLAUDE_CONFIG"
            echo "include .nexus/nexus.md" >> "$CLAUDE_CONFIG"
            print_success "Updated Claude Code configuration"
        fi
    else
        # Create new configuration
        cat > "$CLAUDE_CONFIG" << 'EOF'
# Claude Code Configuration
# Nexus V2 Agent System

# Include all agent definitions
include .nexus/agents/*.md

# Include project context
include .nexus/context/*.md

# Include usage documentation
include .nexus/nexus.md

# Project-specific patterns are loaded dynamically
EOF
        print_success "Created Claude Code configuration"
    fi
}

# Create CLAUDE.md if it doesn't exist
setup_claude_md() {
    if [ ! -f "CLAUDE.md" ]; then
        print_info "Creating CLAUDE.md for project instructions"
        cat > "CLAUDE.md" << 'EOF'
# Project Instructions for Claude Code

## Nexus V2 Integration

This project uses the Nexus V2 agent system. The specialized agents are:

- **Designer Agent**: UI/UX design and product management
- **Architect Agent**: System design and technical architecture
- **Developer Agent**: Implementation and coding
- **Technician Agent**: Debugging and DevOps
- **Discovery Agent**: Research and exploration

Refer to `.nexus/nexus.md` for detailed usage instructions.

## Project-Specific Instructions

<!-- Add your project-specific instructions here -->
EOF
        print_success "Created CLAUDE.md"
    fi
}

# Update .gitignore
update_gitignore() {
    print_header "Updating .gitignore"
    
    if [ ! -f ".gitignore" ]; then
        touch .gitignore
    fi
    
    # Check if Nexus patterns are already ignored
    if ! grep -q "\.nexus/learning/" ".gitignore"; then
        echo "" >> .gitignore
        echo "# Nexus V2" >> .gitignore
        echo ".nexus/learning/" >> .gitignore
        echo ".nexus/patterns/**/*.json" >> .gitignore
        print_success "Updated .gitignore"
    else
        print_info ".gitignore already configured"
    fi
}

# Display next steps
show_next_steps() {
    print_header "Installation Complete! 🎉"
    
    echo "Nexus V2 has been successfully installed in your project."
    echo ""
    echo "Next steps:"
    echo "1. Review the agents in ${BLUE}.nexus/agents/${NC}"
    echo "2. Read the usage guide in ${BLUE}.nexus/nexus.md${NC}"
    echo "3. Customize ${BLUE}.nexus/context/ideals.md${NC} for your project"
    echo "4. Start using agents with natural language triggers:"
    echo ""
    echo "   ${GREEN}Examples:${NC}"
    echo "   - \"Design a user authentication flow\""
    echo "   - \"How should we architect the payment system?\""
    echo "   - \"Implement the shopping cart feature\""
    echo "   - \"Debug the slow API response\""
    echo "   - \"Research best practices for caching\""
    echo ""
    echo "For more information, see ${BLUE}.nexus/nexus.md${NC}"
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
    install_learning_system
    install_documentation
    setup_claude_config
    setup_claude_md
    update_gitignore
    
    # Done!
    show_next_steps
}

# Run main function
main "$@"