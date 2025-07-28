#!/bin/bash
# NEXUS Pattern Command - Apply and manage patterns

NEXUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROJECT_ROOT="$(pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Parse command
COMMAND="${1:-list}"
PATTERN_ID="${2:-}"

case "$COMMAND" in
    list)
        echo -e "${BLUE}📚 Available Patterns${NC}"
        echo "===================="
        echo ""
        
        # List local patterns
        if [ -d ".nexus/patterns" ] && [ -n "$(ls -A .nexus/patterns/*.json 2>/dev/null)" ]; then
            echo -e "${CYAN}Local Patterns:${NC}"
            for pattern in .nexus/patterns/*.json; do
                name=$(jq -r '.name' "$pattern" 2>/dev/null || echo "Unknown")
                category=$(jq -r '.category' "$pattern" 2>/dev/null || echo "uncategorized")
                id=$(jq -r '.id' "$pattern" 2>/dev/null || basename "$pattern" .json)
                echo "  - [$category] $name (ID: $id)"
            done
            echo ""
        fi
        
        # List vault patterns
        if [ -d "$NEXUS_ROOT/vault/patterns" ]; then
            echo -e "${CYAN}NEXUS Vault Patterns:${NC}"
            for pattern in "$NEXUS_ROOT/vault/patterns"/*.json; do
                [ -f "$pattern" ] || continue
                name=$(jq -r '.name' "$pattern" 2>/dev/null || echo "Unknown")
                category=$(jq -r '.category' "$pattern" 2>/dev/null || echo "uncategorized")
                id=$(jq -r '.id' "$pattern" 2>/dev/null || basename "$pattern" .json)
                echo "  - [$category] $name (ID: $id)"
            done
        fi
        ;;
        
    show)
        if [ -z "$PATTERN_ID" ]; then
            echo -e "${RED}❌ Error: Pattern ID required${NC}"
            echo "Usage: nexus-pattern show <pattern-id>"
            exit 1
        fi
        
        # Find pattern file
        PATTERN_FILE=""
        if [ -f ".nexus/patterns/${PATTERN_ID}.json" ]; then
            PATTERN_FILE=".nexus/patterns/${PATTERN_ID}.json"
        elif [ -f "$NEXUS_ROOT/vault/patterns/${PATTERN_ID}.json" ]; then
            PATTERN_FILE="$NEXUS_ROOT/vault/patterns/${PATTERN_ID}.json"
        else
            echo -e "${RED}❌ Pattern not found: $PATTERN_ID${NC}"
            exit 1
        fi
        
        # Display pattern details
        echo -e "${BLUE}📋 Pattern: $(jq -r '.name' "$PATTERN_FILE")${NC}"
        echo "================================"
        echo ""
        jq . "$PATTERN_FILE"
        ;;
        
    apply)
        if [ -z "$PATTERN_ID" ]; then
            echo -e "${RED}❌ Error: Pattern ID required${NC}"
            echo "Usage: nexus-pattern apply <pattern-id>"
            exit 1
        fi
        
        # Find pattern file
        PATTERN_FILE=""
        if [ -f ".nexus/patterns/${PATTERN_ID}.json" ]; then
            PATTERN_FILE=".nexus/patterns/${PATTERN_ID}.json"
        elif [ -f "$NEXUS_ROOT/vault/patterns/${PATTERN_ID}.json" ]; then
            PATTERN_FILE="$NEXUS_ROOT/vault/patterns/${PATTERN_ID}.json"
        else
            echo -e "${RED}❌ Pattern not found: $PATTERN_ID${NC}"
            exit 1
        fi
        
        echo -e "${BLUE}🎯 Applying Pattern: $(jq -r '.name' "$PATTERN_FILE")${NC}"
        echo "===================================="
        echo ""
        
        # Check applicability
        PROJECT_TYPE=$(jq -r '.nexus_project_type // "unknown"' .nexus/config/project.yaml 2>/dev/null)
        APPLICABLE_TYPES=$(jq -r '.applicability.project_types[]' "$PATTERN_FILE" 2>/dev/null)
        
        # Apply files
        echo -e "${CYAN}📁 Creating files...${NC}"
        jq -r '.implementation.files | to_entries[] | "\(.key)|\(.value)"' "$PATTERN_FILE" | while IFS='|' read -r filepath content; do
            # Create directory if needed
            dir=$(dirname "$filepath")
            [ "$dir" != "." ] && mkdir -p "$dir"
            
            # Interpolate variables
            echo "$content" > "$filepath"
            echo "   ✓ Created: $filepath"
        done
        
        # Add dependencies
        if [ -f "package.json" ]; then
            echo ""
            echo -e "${CYAN}📦 Dependencies to add:${NC}"
            jq -r '.implementation.dependencies | to_entries[] | "npm install --save-dev \(.key)@\(.value)"' "$PATTERN_FILE" 2>/dev/null
            
            echo ""
            echo -e "${YELLOW}Run the above commands to install dependencies${NC}"
        fi
        
        # Add scripts
        if [ -f "package.json" ]; then
            echo ""
            echo -e "${CYAN}📜 Scripts to add to package.json:${NC}"
            jq '.implementation.scripts' "$PATTERN_FILE" 2>/dev/null
        fi
        
        # Show usage
        echo ""
        echo -e "${GREEN}✅ Pattern applied successfully!${NC}"
        echo ""
        echo -e "${CYAN}Usage:${NC}"
        jq -r '.usage' "$PATTERN_FILE"
        ;;
        
    create)
        echo -e "${BLUE}🎨 Interactive Pattern Creator${NC}"
        echo "=============================="
        echo ""
        
        read -p "Pattern name: " name
        read -p "Category (testing/architecture/etc): " category
        read -p "Description: " description
        read -p "Context (when to use): " context
        
        PATTERN_ID="${category}-$(echo "$name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')-$(date +%s)"
        PATTERN_FILE=".nexus/patterns/${PATTERN_ID}.json"
        
        mkdir -p .nexus/patterns
        
        cat > "$PATTERN_FILE" << EOF
{
  "id": "$PATTERN_ID",
  "name": "$name",
  "version": "1.0.0",
  "category": "$category",
  "description": "$description",
  "context": "$context",
  "source": {
    "project": "$(basename "$PROJECT_ROOT")",
    "discovered": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "created_manually": true
  },
  "applicability": {
    "project_types": ["web-app", "api"],
    "tech_stack": [],
    "tags": []
  },
  "implementation": {
    "files": {},
    "dependencies": {},
    "scripts": {}
  },
  "variables": {},
  "usage": "Edit this pattern file to add implementation details",
  "learnings": ""
}
EOF
        
        echo ""
        echo -e "${GREEN}✅ Pattern created: $PATTERN_FILE${NC}"
        echo "   Edit the file to add implementation details"
        ;;
        
    interpolate)
        # Used by agents to interpolate patterns into prompts
        if [ -z "$PATTERN_ID" ]; then
            echo "Error: Pattern ID required"
            exit 1
        fi
        
        # Find pattern file
        PATTERN_FILE=""
        if [ -f ".nexus/patterns/${PATTERN_ID}.json" ]; then
            PATTERN_FILE=".nexus/patterns/${PATTERN_ID}.json"
        elif [ -f "$NEXUS_ROOT/vault/patterns/${PATTERN_ID}.json" ]; then
            PATTERN_FILE="$NEXUS_ROOT/vault/patterns/${PATTERN_ID}.json"
        else
            echo "Pattern not found: $PATTERN_ID"
            exit 1
        fi
        
        # Output pattern for agent consumption
        echo "=== PATTERN: $(jq -r '.name' "$PATTERN_FILE") ==="
        echo "Category: $(jq -r '.category' "$PATTERN_FILE")"
        echo "Description: $(jq -r '.description' "$PATTERN_FILE")"
        echo ""
        echo "Implementation:"
        jq -r '.implementation.files | to_entries[] | "File: \(.key)\nContent:\n\(.value)\n"' "$PATTERN_FILE"
        echo ""
        echo "Dependencies:"
        jq -r '.implementation.dependencies | to_entries[] | "\(.key): \(.value)"' "$PATTERN_FILE"
        echo ""
        echo "Usage: $(jq -r '.usage' "$PATTERN_FILE")"
        echo "=== END PATTERN ==="
        ;;
        
    *)
        echo "Usage: nexus-pattern [command] [pattern-id]"
        echo ""
        echo "Commands:"
        echo "  list        List available patterns"
        echo "  show        Show pattern details"
        echo "  apply       Apply pattern to current project"
        echo "  create      Create new pattern interactively"
        echo "  interpolate Output pattern for agent use"
        ;;
esac