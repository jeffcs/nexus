# Pattern Usage in Forge Agent

## How Patterns Work with Agents

When you reference a pattern in a prompt, Forge can:

1. **Load Pattern Data**
   ```bash
   # Agent internally calls:
   nexus-pattern interpolate supabase-auth
   ```

2. **Apply Pattern Files**
   - Creates all files defined in the pattern
   - Interpolates variables
   - Respects project structure

3. **Smart Integration**
   - Merges dependencies into package.json
   - Adds scripts without overwriting
   - Handles conflicts gracefully

## Example Usage

### User Prompt:
"Add authentication using @vault/patterns/supabase-auth"

### Forge Process:
1. Loads pattern JSON
2. Analyzes current project structure
3. Creates authentication files:
   - `lib/supabase.ts`
   - `hooks/useAuth.tsx`
   - `components/AuthProvider.tsx`
4. Updates package.json with dependencies
5. Provides integration instructions

## Pattern Variables

Patterns can use variables that get replaced:
- `{{PROJECT_NAME}}` - Current project name
- `{{BASE_URL}}` - Project URL
- `{{API_KEY}}` - Environment-specific keys

## Advanced Pattern Usage

### Combining Patterns
```
"Apply patterns supabase-auth and playwright-e2e together"
```

### Modifying Patterns
```
"Use supabase-auth pattern but with custom user fields"
```

### Pattern-Based Refactoring
```
"Refactor our auth to match the supabase-auth pattern"
```

## Pattern Discovery

Forge can suggest patterns:
- Based on project type
- From similar implementations
- When detecting anti-patterns

## Creating Patterns from Code

When Forge creates something novel:
1. Recognizes reusable solution
2. Suggests pattern extraction
3. Helps generalize for other projects