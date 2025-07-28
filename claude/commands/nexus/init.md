# nexus:init

Initialize or update NEXUS in the current project directory.

## Usage

This command will:
1. Check if NEXUS is already installed in the current project
2. Compare installed version with the latest NEXUS version
3. Offer to update if versions don't match
4. Create a new NEXUS installation if not present

## Process

The initialization process will:
- Create `.nexus/` directory structure in your project
- Copy essential NEXUS components
- Set up project-specific configuration
- Create initial agent configurations
- Set up Claude Code integration files

## Options

- `--force`: Force reinstall even if up to date
- `--minimal`: Install only core components
- `--full`: Install all components including examples

## Example

```bash
# In your project directory
/nexus:init

# Force update
/nexus:init --force
```