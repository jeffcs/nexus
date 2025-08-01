# Architect Patterns

## Pattern: API Design - RESTful Resources

**Context**: Consistent API design for resources

**Structure**:
```
GET    /api/v1/users          # List
GET    /api/v1/users/:id      # Read
POST   /api/v1/users          # Create
PATCH  /api/v1/users/:id      # Update
DELETE /api/v1/users/:id      # Delete
```

**Response Format**:
```json
{
  "data": { /* resource */ },
  "meta": {
    "version": "1.0",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}
```

---

## Pattern: Database Schema - Audit Fields

**Context**: Track changes and maintain data integrity

**Structure**:
```sql
CREATE TABLE users (
  -- Primary fields
  id         UUID PRIMARY KEY,
  email      VARCHAR(255) UNIQUE NOT NULL,
  
  -- Audit fields (always include)
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES users(id),
  updated_by UUID REFERENCES users(id),
  version    INTEGER NOT NULL DEFAULT 1
);
```