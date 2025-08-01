#!/bin/bash
# Nexus Agent Hot-Reload System
# Monitors agent files and automatically reloads changes

set -e

# Configuration
NEXUS_ROOT="${NEXUS_ROOT:-$(dirname $(dirname $(dirname "$0")))}"
AGENTS_DIR="$NEXUS_ROOT/.claude/agents"
VERSIONS_DIR="$NEXUS_ROOT/.nexus/evaluation/versions"
PATTERNS_DIR="$NEXUS_ROOT/.nexus/patterns"
WATCH_INTERVAL=2

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Initialize monitoring
echo -e "${GREEN}🔄 Nexus Hot-Reload System Started${NC}"
echo "Watching for changes in:"
echo "  - Agent definitions: $AGENTS_DIR"
echo "  - Version variants: $VERSIONS_DIR"
echo "  - Pattern files: $PATTERNS_DIR"
echo ""

# Track file checksums
declare -A checksums

# Calculate checksum for a file
get_checksum() {
    if [[ -f "$1" ]]; then
        if command -v md5sum > /dev/null; then
            md5sum "$1" | cut -d' ' -f1
        else
            md5 -q "$1"
        fi
    else
        echo ""
    fi
}

# Initialize checksums
initialize_checksums() {
    # Agent files
    for agent_file in "$AGENTS_DIR"/*.md; do
        if [[ -f "$agent_file" ]]; then
            checksums["$agent_file"]=$(get_checksum "$agent_file")
        fi
    done
    
    # Version files
    if [[ -d "$VERSIONS_DIR" ]]; then
        for version_file in "$VERSIONS_DIR"/*/*.md; do
            if [[ -f "$version_file" ]]; then
                checksums["$version_file"]=$(get_checksum "$version_file")
            fi
        done
    fi
    
    # Pattern files
    for pattern_file in "$PATTERNS_DIR"/*.md; do
        if [[ -f "$pattern_file" ]]; then
            checksums["$pattern_file"]=$(get_checksum "$pattern_file")
        fi
    done
}

# Apply a version variant to an agent
apply_variant() {
    local variant_file="$1"
    local agent_name=$(basename $(dirname "$variant_file"))
    local agent_file="$AGENTS_DIR/$agent_name.md"
    local backup_file="$AGENTS_DIR/.$agent_name.md.backup"
    
    # Create backup if it doesn't exist
    if [[ ! -f "$backup_file" ]]; then
        cp "$agent_file" "$backup_file"
        echo -e "${YELLOW}📦 Created backup: $backup_file${NC}"
    fi
    
    # Apply variant
    cp "$variant_file" "$agent_file"
    echo -e "${GREEN}✅ Applied variant: $(basename "$variant_file") to $agent_name${NC}"
}

# Restore original agent from backup
restore_agent() {
    local agent_name="$1"
    local agent_file="$AGENTS_DIR/$agent_name.md"
    local backup_file="$AGENTS_DIR/.$agent_name.md.backup"
    
    if [[ -f "$backup_file" ]]; then
        cp "$backup_file" "$agent_file"
        echo -e "${GREEN}♻️  Restored original: $agent_name${NC}"
    fi
}

# Check for file changes
check_changes() {
    local changes_detected=false
    
    # Check agent files
    for agent_file in "$AGENTS_DIR"/*.md; do
        if [[ -f "$agent_file" ]]; then
            local current_checksum=$(get_checksum "$agent_file")
            local stored_checksum="${checksums[$agent_file]}"
            
            if [[ "$current_checksum" != "$stored_checksum" ]]; then
                changes_detected=true
                checksums["$agent_file"]="$current_checksum"
                local agent_name=$(basename "$agent_file" .md)
                echo -e "${GREEN}🔄 Agent updated: $agent_name${NC}"
                
                # Trigger reload notification
                notify_reload "$agent_name" "agent"
            fi
        fi
    done
    
    # Check version files
    if [[ -d "$VERSIONS_DIR" ]]; then
        for version_file in "$VERSIONS_DIR"/*/*.md; do
            if [[ -f "$version_file" ]]; then
                local current_checksum=$(get_checksum "$version_file")
                local stored_checksum="${checksums[$version_file]}"
                
                if [[ "$current_checksum" != "$stored_checksum" ]]; then
                    changes_detected=true
                    checksums["$version_file"]="$current_checksum"
                    local variant_name=$(basename "$version_file" .md)
                    local agent_name=$(basename $(dirname "$version_file"))
                    echo -e "${YELLOW}📝 Variant updated: $agent_name/$variant_name${NC}"
                    
                    # Auto-apply if in test mode
                    if [[ "$HOT_RELOAD_MODE" == "test" ]]; then
                        apply_variant "$version_file"
                    fi
                fi
            fi
        done
    fi
    
    # Check pattern files
    for pattern_file in "$PATTERNS_DIR"/*.md; do
        if [[ -f "$pattern_file" ]]; then
            local current_checksum=$(get_checksum "$pattern_file")
            local stored_checksum="${checksums[$pattern_file]}"
            
            if [[ "$current_checksum" != "$stored_checksum" ]]; then
                changes_detected=true
                checksums["$pattern_file"]="$current_checksum"
                local agent_name=$(basename "$pattern_file" .md)
                echo -e "${GREEN}📚 Patterns updated: $agent_name${NC}"
                
                # Trigger reload notification
                notify_reload "$agent_name" "patterns"
            fi
        fi
    done
    
    return $([ "$changes_detected" = true ] && echo 0 || echo 1)
}

# Notify system of reload (placeholder for future integration)
notify_reload() {
    local component="$1"
    local type="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log reload event
    echo "$timestamp: Reload $type for $component" >> "$NEXUS_ROOT/.nexus/evaluation/reload.log"
    
    # Future: Send notification to Claude Code or evaluation system
}

# Handle shutdown
cleanup() {
    echo -e "\n${YELLOW}🛑 Shutting down hot-reload system...${NC}"
    
    # Restore any variants if in test mode
    if [[ "$HOT_RELOAD_MODE" == "test" ]]; then
        for agent_file in "$AGENTS_DIR"/.*.md.backup; do
            if [[ -f "$agent_file" ]]; then
                local agent_name=$(basename "$agent_file" .md.backup | sed 's/^\.//')
                restore_agent "$agent_name"
            fi
        done
    fi
    
    echo -e "${GREEN}✅ Hot-reload system stopped${NC}"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Main monitoring loop
main() {
    # Initialize
    initialize_checksums
    
    # Monitor loop
    while true; do
        if check_changes; then
            # Changes detected and processed
            :
        fi
        
        # Wait before next check
        sleep $WATCH_INTERVAL
    done
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --mode)
            HOT_RELOAD_MODE="$2"
            shift 2
            ;;
        --interval)
            WATCH_INTERVAL="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --mode MODE      Set hot-reload mode (watch|test)"
            echo "  --interval SEC   Set watch interval in seconds (default: 2)"
            echo "  --help          Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Start monitoring
main