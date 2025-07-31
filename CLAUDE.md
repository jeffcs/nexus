# Nexus V2 Framework Development

## About This Repository

This is the source code for the Nexus V2 agent framework for Claude Code. The framework provides five specialized AI agents that work together to help developers build better software.

## Development Guidelines

When working on this codebase:

1. **Agent Quality**: Maintain exemplary agent definitions that showcase best practices
2. **Pattern Library**: Keep patterns concise, practical, and reusable
3. **Installation**: Ensure the installation process remains simple and reliable
4. **Documentation**: Keep all documentation clear and up-to-date
5. **Testing**: Run `./test-nexus.sh` to validate changes

## Project Structure

```
agents/          # Source agent definitions
patterns/        # Pattern examples for each agent
context/         # Context templates for projects
install-nexus.sh # Installation script
test-nexus.sh    # Test suite
nexus.md        # User guide
```

## The Agents

- **product**: Product strategy, research, and validation
- **designer**: UI/UX design and user experience
- **architect**: System design and technical architecture
- **developer**: Implementation and coding
- **technician**: Debugging, DevOps, and operations

## Making Changes

1. Edit agent definitions in `agents/[agent].md`
2. Update patterns in `patterns/[agent].md`
3. Test with `./test-nexus.sh`
4. Update documentation as needed
5. Create PR with clear description

Remember: This framework should exemplify the best practices it promotes.