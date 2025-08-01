#!/bin/bash
# NEXUS Learn Command - Extract patterns from project evolution

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check if we're in a NEXUS-initialized project
if [ ! -f ".nexus-project" ]; then
    echo -e "${RED}❌ Error: Not in a NEXUS-initialized project${NC}"
    echo "Run /nexus/init first to initialize NEXUS in this project"
    exit 1
fi

PROJECT_ROOT="$(pwd)"
NEXUS_LOCAL="$PROJECT_ROOT/.nexus"
GUIDANCE="${*:-}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Find the NEXUS source directory
if [ -n "$NEXUS_ROOT" ]; then
    NEXUS_SOURCE="$NEXUS_ROOT"
elif [ -d "$HOME/work/nexus" ]; then
    NEXUS_SOURCE="$HOME/work/nexus"
else
    echo -e "${RED}❌ Error: Cannot find NEXUS source directory${NC}"
    echo "Set NEXUS_ROOT environment variable"
    exit 1
fi

echo -e "${BLUE}🧠 NEXUS Learning System${NC}"
echo "========================"
echo ""
if [ -n "$GUIDANCE" ]; then
    echo -e "${CYAN}📋 Focus:${NC} $GUIDANCE"
else
    echo -e "${CYAN}📋 Mode:${NC} Comprehensive analysis"
fi
echo ""

# Create local patterns directory
mkdir -p "$NEXUS_LOCAL/patterns"
mkdir -p "$NEXUS_LOCAL/learnings"

# Get project initialization date
INIT_DATE=$(jq -r '.initialized // ""' "$NEXUS_LOCAL/config/project.yaml" 2>/dev/null || echo "")
if [ -z "$INIT_DATE" ]; then
    INIT_DATE=$(find "$NEXUS_LOCAL" -type f -name "project.yaml" -exec stat -f "%B" {} \; 2>/dev/null | head -1)
    if [ -n "$INIT_DATE" ]; then
        INIT_DATE=$(date -r "$INIT_DATE" -u +"%Y-%m-%dT%H:%M:%SZ")
    fi
fi

echo -e "${BLUE}📊 Analyzing project evolution...${NC}"
echo ""

# Analyze git history since NEXUS initialization
LEARNING_REPORT="$NEXUS_LOCAL/learnings/report-$(date +%Y%m%d-%H%M%S).md"

cat > "$LEARNING_REPORT" << EOF
# NEXUS Learning Report

> Project: $(basename "$PROJECT_ROOT")
> Generated: $TIMESTAMP
> Guidance: ${GUIDANCE:-Comprehensive analysis}

## Git History Analysis

### Commits Since NEXUS Init
EOF

# Analyze commits
if [ -d ".git" ]; then
    echo "" >> "$LEARNING_REPORT"
    echo "\`\`\`" >> "$LEARNING_REPORT"
    if [ -n "$INIT_DATE" ]; then
        git log --since="$INIT_DATE" --oneline | head -20 >> "$LEARNING_REPORT"
    else
        git log --oneline | head -20 >> "$LEARNING_REPORT"
    fi
    echo "\`\`\`" >> "$LEARNING_REPORT"
    
    # Count changes
    COMMIT_COUNT=$(git log --since="$INIT_DATE" --oneline 2>/dev/null | wc -l | tr -d ' ')
    FILE_COUNT=$(git diff --name-only $(git log --since="$INIT_DATE" --format="%H" | tail -1 2>/dev/null)..HEAD 2>/dev/null | wc -l | tr -d ' ')
    
    echo "" >> "$LEARNING_REPORT"
    echo "**Metrics:**" >> "$LEARNING_REPORT"
    echo "- Commits: $COMMIT_COUNT" >> "$LEARNING_REPORT"
    echo "- Files changed: $FILE_COUNT" >> "$LEARNING_REPORT"
fi

# Identify key changes
echo "" >> "$LEARNING_REPORT"
echo "## Key Innovations" >> "$LEARNING_REPORT"
echo "" >> "$LEARNING_REPORT"

# Check for new test frameworks
if [ -f "playwright.config.js" ] || [ -f "playwright.config.ts" ]; then
    echo "### Testing Framework: Playwright" >> "$LEARNING_REPORT"
    echo "- End-to-end testing capability added" >> "$LEARNING_REPORT"
    echo "- Configuration: playwright.config.*" >> "$LEARNING_REPORT"
    
    # Create a pattern for Playwright
    PATTERN_ID="playwright-e2e-$(date +%s)"
    PATTERN_FILE="$NEXUS_LOCAL/patterns/${PATTERN_ID}.json"
    
    cat > "$PATTERN_FILE" << EOFPATTERN
{
  "id": "$PATTERN_ID",
  "name": "Playwright E2E Testing Setup",
  "version": "1.0.0",
  "category": "testing",
  "description": "Complete Playwright setup for end-to-end testing",
  "context": "Use when you need reliable E2E testing for web applications",
  "source": {
    "project": "$(basename "$PROJECT_ROOT")",
    "discovered": "$TIMESTAMP",
    "guidance": "$GUIDANCE"
  },
  "applicability": {
    "project_types": ["web-app"],
    "tech_stack": ["javascript", "typescript", "react", "vue", "angular"],
    "tags": ["testing", "e2e", "playwright", "automation"]
  },
  "implementation": {
    "files": {
      "playwright.config.js": "// Playwright configuration\n$(cat playwright.config.* 2>/dev/null | head -50 | sed 's/"/\\"/g' | tr '\n' '\\n' || echo "export default {};")",
      "tests/e2e/example.spec.js": "import { test, expect } from '@playwright/test';\n\ntest('example test', async ({ page }) => {\n  await page.goto('/');\n  await expect(page).toHaveTitle(/Home/);\n});"
    },
    "dependencies": {
      "@playwright/test": "^1.40.0"
    },
    "scripts": {
      "test:e2e": "playwright test",
      "test:e2e:ui": "playwright test --ui",
      "test:e2e:debug": "playwright test --debug"
    }
  },
  "variables": {
    "BASE_URL": "http://localhost:3000",
    "TIMEOUT": "30000"
  },
  "usage": "Install dependencies and run: npm run test:e2e",
  "learnings": "Playwright provides excellent debugging tools and cross-browser testing"
}
EOFPATTERN
    
    echo "" >> "$LEARNING_REPORT"
    echo "✅ Pattern created: $PATTERN_ID" >> "$LEARNING_REPORT"
fi

# Check for authentication patterns
if find . -name "*auth*" -o -name "*supabase*" -o -name "*clerk*" | grep -q .; then
    echo "" >> "$LEARNING_REPORT"
    echo "### Authentication System" >> "$LEARNING_REPORT"
    echo "- Custom auth implementation detected" >> "$LEARNING_REPORT"
    echo "- Files: $(find . -name "*auth*" -type f | head -5 | tr '\n' ', ')" >> "$LEARNING_REPORT"
fi

# Check for CI/CD improvements
if [ -d ".github/workflows" ]; then
    echo "" >> "$LEARNING_REPORT"
    echo "### CI/CD Workflows" >> "$LEARNING_REPORT"
    echo "- GitHub Actions workflows detected" >> "$LEARNING_REPORT"
    echo "- Workflows: $(ls .github/workflows/*.yml 2>/dev/null | wc -l | tr -d ' ')" >> "$LEARNING_REPORT"
fi

# Analyze package.json changes
if [ -f "package.json" ]; then
    echo "" >> "$LEARNING_REPORT"
    echo "### New Dependencies" >> "$LEARNING_REPORT"
    echo "" >> "$LEARNING_REPORT"
    
    # This is simplified - in reality we'd diff against the original
    echo "\`\`\`json" >> "$LEARNING_REPORT"
    jq '.dependencies' package.json | head -20 >> "$LEARNING_REPORT"
    echo "\`\`\`" >> "$LEARNING_REPORT"
fi

# Pattern recommendations
echo "" >> "$LEARNING_REPORT"
echo "## Pattern Extraction Opportunities" >> "$LEARNING_REPORT"
echo "" >> "$LEARNING_REPORT"

if [ -n "$GUIDANCE" ]; then
    echo "Based on your guidance: \"$GUIDANCE\"" >> "$LEARNING_REPORT"
    echo "" >> "$LEARNING_REPORT"
    echo "### Recommended Actions:" >> "$LEARNING_REPORT"
    echo "1. Review the extracted patterns in .nexus/patterns/" >> "$LEARNING_REPORT"
    echo "2. Test patterns in a fresh project" >> "$LEARNING_REPORT"
    echo "3. Submit to NEXUS vault if successful" >> "$LEARNING_REPORT"
else
    echo "1. **Testing Patterns**: Extract test setup and helpers" >> "$LEARNING_REPORT"
    echo "2. **Build Configuration**: Capture optimized build settings" >> "$LEARNING_REPORT"
    echo "3. **Component Patterns**: Identify reusable UI components" >> "$LEARNING_REPORT"
    echo "4. **API Patterns**: Extract API client configurations" >> "$LEARNING_REPORT"
fi

# Blueprint update proposals
echo "" >> "$LEARNING_REPORT"
echo "## Blueprint Update Proposals" >> "$LEARNING_REPORT"
echo "" >> "$LEARNING_REPORT"

if [ -n "$PATTERN_FILE" ] && [[ "$GUIDANCE" =~ "blueprint" ]]; then
    echo "### Proposed Update: web-app blueprint" >> "$LEARNING_REPORT"
    echo "" >> "$LEARNING_REPORT"
    echo "Add Playwright E2E testing to the standard web-app blueprint:" >> "$LEARNING_REPORT"
    echo "- Include playwright.config.js in template" >> "$LEARNING_REPORT"
    echo "- Add test:e2e scripts to package.json" >> "$LEARNING_REPORT"
    echo "- Create example test files" >> "$LEARNING_REPORT"
    echo "- Update documentation" >> "$LEARNING_REPORT"
    
    # Create blueprint update proposal
    PROPOSAL_FILE="$NEXUS_LOCAL/learnings/blueprint-update-proposal.md"
    cat > "$PROPOSAL_FILE" << EOFPROPOSAL
# Blueprint Update Proposal

## Target: web-app blueprint
## Pattern: $PATTERN_ID

### Changes Required

1. **Add to factory/blueprints/web-app/template/**
   - playwright.config.js
   - tests/e2e/example.spec.js
   - tests/e2e/helpers/

2. **Update package.json template**
   \`\`\`json
   "devDependencies": {
     "@playwright/test": "^1.40.0"
   },
   "scripts": {
     "test:e2e": "playwright test",
     "test:e2e:ui": "playwright test --ui"
   }
   \`\`\`

3. **Update README.md template**
   - Add E2E testing section
   - Include Playwright commands

### Rationale
- E2E testing is now standard practice
- Playwright is the modern choice
- Reduces setup time for new projects

### Migration Guide
For existing projects:
1. Run: npm install -D @playwright/test
2. Copy playwright.config.js
3. Create tests/e2e directory
4. Run: npm run test:e2e

EOFPROPOSAL
    
    echo "" >> "$LEARNING_REPORT"
    echo "✅ Blueprint proposal created: $PROPOSAL_FILE" >> "$LEARNING_REPORT"
fi

# Summary
echo "" >> "$LEARNING_REPORT"
echo "## Summary" >> "$LEARNING_REPORT"
echo "" >> "$LEARNING_REPORT"
echo "- Patterns extracted: $(ls "$NEXUS_LOCAL/patterns"/*.json 2>/dev/null | wc -l | tr -d ' ')" >> "$LEARNING_REPORT"
echo "- Learnings documented: Yes" >> "$LEARNING_REPORT"
echo "- Blueprint updates proposed: $(ls "$NEXUS_LOCAL/learnings"/blueprint-*.md 2>/dev/null | wc -l | tr -d ' ')" >> "$LEARNING_REPORT"

# Display results
echo -e "${GREEN}✅ Learning analysis complete!${NC}"
echo ""
echo "📊 Results:"
echo "   - Learning report: .nexus/learnings/$(basename "$LEARNING_REPORT")"
if [ -n "$PATTERN_FILE" ]; then
    echo "   - Pattern created: .nexus/patterns/$(basename "$PATTERN_FILE")"
fi
if [ -f "$PROPOSAL_FILE" ]; then
    echo "   - Blueprint proposal: .nexus/learnings/$(basename "$PROPOSAL_FILE")"
fi

echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Review the learning report"
echo "2. Test extracted patterns"
echo "3. Submit valuable patterns to NEXUS vault:"
echo "   cp .nexus/patterns/*.json $NEXUS_SOURCE/vault/patterns/"
echo "4. Create PR for blueprint updates if applicable"

# Show pattern interpolation example
if [ -n "$PATTERN_FILE" ]; then
    echo ""
    echo -e "${CYAN}💡 Pattern Usage Example:${NC}"
    echo "The pattern can be applied in new projects:"
    echo ""
    echo "   nexus pattern apply $PATTERN_ID"
    echo ""
    echo "Or referenced in prompts:"
    echo "   'Apply pattern @vault/patterns/$PATTERN_ID for E2E testing'"
fi

# Integration with NEXUS evolution
echo ""
echo -e "${BLUE}🧬 Evolution Integration:${NC}"
echo "To incorporate these learnings into NEXUS core:"
echo "   cd $NEXUS_SOURCE"
echo "   ./self/evolve/evolve.sh upgrade \"integrate $(basename "$PROJECT_ROOT") learnings\""