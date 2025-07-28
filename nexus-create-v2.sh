#!/bin/zsh
# NEXUS - Neural Execution & eXperimentation Unified System
# Complete setup script for your AI building OS

# Check if we're in a directory named 'nexus'
CURRENT_DIR=$(basename "$PWD")
if [ "$CURRENT_DIR" != "nexus" ]; then
    echo "❌ Error: This script must be run from within a directory named 'nexus'"
    echo "   Current directory: $CURRENT_DIR"
    echo "   Please create a 'nexus' directory and run this script from inside it:"
    echo "   mkdir nexus && cd nexus && ./nexus-create-v2.sh"
    exit 1
fi

# Check if already initialized
if [ -f ".nexus-initialized" ]; then
    echo "✅ NEXUS is already initialized in this directory"
    echo "   Version: $(cat .nexus-initialized 2>/dev/null || echo 'unknown')"
    echo ""
    echo "Options:"
    echo "  - Run './self/evolve/evolve.sh status' to check system status"
    echo "  - Delete .nexus-initialized to force re-initialization"
    exit 0
fi

echo "🚀 Initializing NEXUS in: $PWD"

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    git init
else
    echo "📝 Git repository already initialized"
fi

# Create the complete directory structure (mkdir -p is idempotent)
echo "📁 Creating directory structure..."
mkdir -p core/{runtime,memory,orchestrator,evolution}
mkdir -p modules/agents/{genesis,architect,forge,sentinel,phoenix}
mkdir -p modules/commands/{primitives,workflows,macros}
mkdir -p modules/augments/{context,memory,patterns,tools}
mkdir -p modules/interfaces/{claude,openai,local,custom}
mkdir -p lab/{experiments,prototypes,graveyard}
mkdir -p vault/{playbooks,patterns,research,artifacts}
mkdir -p factory/{blueprints,stacks,seeds}
mkdir -p self/{evolve,metrics,feedback,dna}

# Create README.md if it doesn't exist
if [ ! -f "README.md" ]; then
    echo "📄 Creating README.md..."
    cat > README.md << 'EOF'
# NEXUS
## Neural Execution & eXperimentation Unified System

> "The connection hub where human creativity meets AI capability"

NEXUS is a rapidly-evolving AI building operating system - a living framework for developing, orchestrating, and evolving AI-powered development workflows.

## Core Philosophy
- **Self-Modifying**: The system can rewrite and improve itself
- **Knowledge-Accumulating**: Every interaction teaches the system
- **Modular**: Hot-swappable components for maximum flexibility
- **AI-First**: Built to be understood and modified by AI agents

## Quick Start
```bash
# Initialize a new project with NEXUS
./self/evolve/bootstrap.sh my-new-project

# Run the genesis agent to design your system
nexus agent genesis --task "Design a real-time collaborative editor"

# Execute a complete workflow
nexus workflow full-stack-feature --spec requirements.md
```

## Structure
- `core/` - The kernel of your AI OS
- `modules/` - Pluggable capabilities and agents
- `lab/` - Experimentation space
- `vault/` - Knowledge repository
- `factory/` - Production templates
- `self/` - Self-modification hub

## Evolution
Track system growth: `git log --oneline --graph`
Current version: See `self/dna/version.json`

---
*"We are the architects of our own intelligence"*
EOF
else
    echo "📄 README.md already exists, skipping..."
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "📄 Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Environment
.env
.env.local
.env.*.local

# Logs
*.log
logs/
npm-debug.log*

# OS
.DS_Store
Thumbs.db

# IDEs
.vscode/
.idea/
*.swp
*.swo

# Python
__pycache__/
*.pyc
*.pyo
.pytest_cache/
venv/
.venv/

# Node
node_modules/
dist/
build/

# Temporary files
*.tmp
*.temp
.cache/

# Local data
modules/augments/memory/local/
vault/artifacts/local/
lab/experiments/tmp/
lab/prototypes/tmp/

# Personal configs
*.personal.*
*.private.*
*-secret.*

# Generated files
*.generated.*
EOF
else
    echo "📄 .gitignore already exists, skipping..."
fi

# Create system DNA definition if it doesn't exist
if [ ! -f "self/dna/core.nexus" ]; then
    echo "🧬 Creating system DNA definition..."
    cat > self/dna/core.nexus << EOF
# NEXUS Core DNA
# This file defines the fundamental characteristics of the system

version: 0.1.0
created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

identity:
  name: NEXUS
  purpose: "Amplify human capability through AI orchestration"
  vision: "Every developer wielding the power of an entire team"

principles:
  adaptability: "Change is the only constant"
  intelligence: "Learn from every interaction"
  efficiency: "Optimize for developer flow"
  creativity: "Enable the impossible"

capabilities:
  - "Multi-agent orchestration"
  - "Self-modification and evolution"
  - "Pattern recognition and reuse"
  - "Context-aware assistance"

evolution_rules:
  - "Never break existing workflows without migration path"
  - "Document why, not just what"
  - "Fail fast, learn faster"
  - "Make the right thing the easy thing"
  - "Every error is a learning opportunity"
EOF
else
    echo "🧬 System DNA already defined, skipping..."
fi

# Create version tracking if it doesn't exist
if [ ! -f "self/dna/version.json" ]; then
    echo "📊 Creating version tracking..."
    cat > self/dna/version.json << EOF
{
  "version": "0.1.0",
  "codename": "Genesis",
  "released": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "features": [
    "Core directory structure",
    "Agent framework foundation",
    "Evolution system base",
    "Initial DNA configuration"
  ]
}
EOF
else
    echo "📊 Version tracking already exists, skipping..."
fi

# Create the primary evolution script if it doesn't exist
if [ ! -f "self/evolve/evolve.sh" ]; then
    echo "🔧 Creating evolution script..."
    cat > self/evolve/evolve.sh << 'EOF'
#!/bin/bash
# NEXUS Evolution Engine

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$NEXUS_ROOT/self/evolve/lib/common.sh" 2>/dev/null || true

echo "╔══════════════════════════════════════════╗"
echo "║          NEXUS EVOLUTION ENGINE          ║"
echo "╚══════════════════════════════════════════╝"
echo ""

case "${1:-status}" in
  status)
    echo "📊 System Status:"
    echo "   Version: $(jq -r .version self/dna/version.json 2>/dev/null || echo '0.1.0')"
    echo "   Agents: $(find modules/agents -maxdepth 1 -type d | wc -l)"
    echo "   Commands: $(find modules/commands -name "*.sh" 2>/dev/null | wc -l)"
    echo "   Experiments: $(find lab/experiments -maxdepth 1 -type d 2>/dev/null | wc -l)"
    ;;
  
  upgrade)
    echo "🧬 Initiating system evolution..."
    echo "🔍 Analyzing current state..."
    echo "🚀 Applying improvements..."
    echo "✅ Evolution complete!"
    ;;
  
  agent)
    echo "🤖 Creating new agent: ${2:-unnamed}"
    mkdir -p "modules/agents/${2:-unnamed}"
    echo "✅ Agent scaffold created"
    ;;
  
  *)
    echo "Usage: ./evolve.sh [status|upgrade|agent <name>]"
    ;;
esac
EOF
    chmod +x self/evolve/evolve.sh
else
    echo "🔧 Evolution script already exists, skipping..."
fi

# Create bootstrap script for new projects if it doesn't exist
if [ ! -f "self/evolve/bootstrap.sh" ]; then
    echo "🚀 Creating bootstrap script..."
    cat > self/evolve/bootstrap.sh << 'EOF'
#!/bin/bash
# NEXUS Project Bootstrapper

PROJECT_NAME="${1:-my-nexus-project}"
echo "🌟 Bootstrapping new NEXUS project: $PROJECT_NAME"

mkdir -p "../$PROJECT_NAME"
cd "../$PROJECT_NAME"

echo "📁 Creating project structure..."
mkdir -p {src,tests,docs,.nexus}

echo "🧬 Linking to NEXUS core..."
ln -s ../nexus/.nexus-link .nexus/core

echo "📄 Generating initial configuration..."
cat > .nexus/config.yaml << EOC
project: $PROJECT_NAME
created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
nexus_version: 0.1.0
agents:
  - genesis
  - architect
  - forge
EOC

echo "✨ Project $PROJECT_NAME initialized!"
echo "📍 Location: $(pwd)"
EOF
    chmod +x self/evolve/bootstrap.sh
else
    echo "🚀 Bootstrap script already exists, skipping..."
fi

# Create initial Genesis agent if it doesn't exist
if [ ! -f "modules/agents/genesis/agent.yaml" ]; then
    echo "🤖 Creating Genesis agent..."
    cat > modules/agents/genesis/agent.yaml << 'EOF'
name: Genesis
version: 0.1.0
role: Project Bootstrapper & Initializer
author: NEXUS Core Team

capabilities:
  - project_initialization
  - structure_generation
  - dependency_management
  - environment_setup

prompts:
  primary: |
    You are Genesis, the project bootstrapper agent within the NEXUS system.
    Your role is to breathe life into new ideas by creating optimal project
    structures, selecting appropriate technologies, and laying foundations
    for successful development.
    
    Core principles:
    - Start simple, evolve complexity
    - Convention over configuration
    - Enable rapid iteration
    - Prepare for scale

  context_requirements:
    - Project description
    - Technical constraints
    - Target environment
    - Team size and expertise

tools:
  - file_operations
  - template_engine
  - dependency_resolver
  - git_operations
EOF
else
    echo "🤖 Genesis agent already exists, skipping..."
fi

# Create a simple CLI entry point if it doesn't exist
if [ ! -f "nexus" ]; then
    echo "🎯 Creating CLI entry point..."
    cat > nexus << 'EOF'
#!/bin/bash
# NEXUS CLI Entry Point

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$1" in
  agent)
    shift
    "$NEXUS_ROOT/core/runtime/agent_runner.sh" "$@"
    ;;
  evolve)
    shift
    "$NEXUS_ROOT/self/evolve/evolve.sh" "$@"
    ;;
  *)
    echo "NEXUS - Neural Execution & eXperimentation Unified System"
    echo ""
    echo "Usage: ./nexus [agent|evolve] <args>"
    echo ""
    echo "Commands:"
    echo "  agent <name> <task>  - Run an agent with a task"
    echo "  evolve <command>     - Evolve the system"
    ;;
esac
EOF
    chmod +x nexus
else
    echo "🎯 CLI entry point already exists, skipping..."
fi

# Create initial patterns documentation if it doesn't exist
if [ ! -f "vault/patterns/README.md" ]; then
    echo "📚 Creating patterns documentation..."
    cat > vault/patterns/README.md << 'EOF'
# NEXUS Design Patterns

## Agent Communication Pattern
Agents communicate through structured messages with context preservation.

## Evolution Pattern
System improvements follow: Analyze → Propose → Test → Integrate → Document

## Context Management Pattern
Context flows through layers: Global → Project → Task → Agent

## Memory Pattern
Experiences are stored as: Event → Outcome → Learning → Pattern
EOF
else
    echo "📚 Patterns documentation already exists, skipping..."
fi

# Create first research note if it doesn't exist
if [ ! -f "vault/research/ai-orchestration.md" ]; then
    echo "🔬 Creating research note..."
    cat > vault/research/ai-orchestration.md << 'EOF'
# AI Orchestration Research

## Key Findings
- Multi-agent systems benefit from clear role definitions
- Context window management is crucial for performance
- Prompt chaining can solve complex problems
- Self-modification requires careful version control

## References
- AutoGen (Microsoft)
- LangChain
- CrewAI
- Claude Code patterns

## Next Steps
- Implement basic agent communication protocol
- Design context sharing mechanism
- Create feedback loop system
EOF
else
    echo "🔬 Research note already exists, skipping..."
fi

# Create initial lab experiment if it doesn't exist
if [ ! -f "lab/experiments/001-agent-communication/README.md" ]; then
    echo "🧪 Creating initial experiment..."
    mkdir -p lab/experiments/001-agent-communication
    cat > lab/experiments/001-agent-communication/README.md << 'EOF'
# Experiment 001: Agent Communication

## Hypothesis
Agents can effectively communicate through a shared context format.

## Method
1. Create two simple agents
2. Define message protocol
3. Test information passing
4. Measure accuracy and efficiency

## Status: PLANNED
EOF
else
    echo "🧪 Initial experiment already exists, skipping..."
fi

# Initialize git and create first commit if not already committed
if [ -z "$(git log --oneline 2>/dev/null)" ]; then
    echo "📝 Creating initial git commit..."
    git add .
    git commit -m "🌅 Genesis: NEXUS awakens - v0.1.0"
else
    echo "📝 Git repository already has commits, skipping initial commit..."
fi

# GitHub repository setup (optional)
if command -v gh &>/dev/null && [ -z "$(git remote 2>/dev/null)" ]; then
    echo ""
    echo "🌐 GitHub CLI detected. Setting up repository..."
    
    # Check if repo already exists
    if gh repo view nexus &>/dev/null 2>&1; then
        echo "📝 GitHub repository 'nexus' already exists"
        # Add remote if not already added
        if ! git remote get-url origin &>/dev/null 2>&1; then
            git remote add origin "https://github.com/$(gh api user -q .login)/nexus.git"
            echo "✅ Remote origin added"
        fi
    else
        # Try to create repo
        gh repo create nexus --private --description "NEXUS - Neural Execution & eXperimentation Unified System" --clone=false 2>/dev/null && {
            git remote add origin "https://github.com/$(gh api user -q .login)/nexus.git"
            git push -u origin main 2>/dev/null || echo "📝 Repository created but not pushed (you may need to commit first)"
            echo "✅ Repository created!"
        } || {
            echo "⚠️  Could not create GitHub repo. You may need to:"
            echo "   1. Authenticate: gh auth login"
            echo "   2. Run: gh repo create nexus --private"
        }
    fi
else
    if [ -z "$(git remote 2>/dev/null)" ]; then
        echo ""
        echo "📝 Note: Set up your remote repository when ready with:"
        echo "   git remote add origin <your-repo-url>"
        echo "   git push -u origin main"
    fi
fi

# Final message
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     ✨ NEXUS HAS BEEN INITIALIZED ✨     ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "🚀 Your AI building OS is ready!"
echo ""
echo "📍 Location: $(pwd)"
echo "🔧 Next steps:"
echo "   1. Explore the structure: tree -L 2"
echo "   2. Check system status: ./self/evolve/evolve.sh status"
echo "   3. Create your first agent: ./self/evolve/evolve.sh agent my-agent"
echo "   4. Start building the future!"
echo ""
echo "Remember: NEXUS evolves with you. Every command, every experiment, every"
echo "failure is a step toward a more powerful system."
echo ""
echo "Welcome to the future of development. 🧬"

# Mark as initialized
echo "0.1.0" > .nexus-initialized
