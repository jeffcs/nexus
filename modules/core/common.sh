#!/bin/bash
# NEXUS Common Functions and Variables

# NEXUS root directory
export NEXUS_ROOT="${NEXUS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

# Color codes
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export YELLOW='\033[1;33m'
export NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure directory exists
ensure_dir() {
    local dir="$1"
    [ ! -d "$dir" ] && mkdir -p "$dir"
}

# Safe file operations
safe_copy() {
    local src="$1"
    local dst="$2"
    
    if [ -f "$dst" ]; then
        log_warning "File exists: $dst (backing up)"
        cp "$dst" "${dst}.backup.$(date +%s)"
    fi
    cp "$src" "$dst"
}

# JSON operations (using jq if available)
json_get() {
    local file="$1"
    local key="$2"
    
    if command_exists jq; then
        jq -r "$key" "$file" 2>/dev/null
    else
        grep "\"${key##*.}\"" "$file" | cut -d'"' -f4
    fi
}

# Export common paths
export NEXUS_VAULT="$NEXUS_ROOT/vault"
export NEXUS_SELF="$NEXUS_ROOT/self"
export NEXUS_MODULES="$NEXUS_ROOT/modules"
export NEXUS_CLAUDE="$NEXUS_ROOT/claude"