# API Architecture Patterns

> Category: System Design
> Agent: Architect
> Last Updated: 2025-01-31

## Pattern: Resource-Based REST API

### Context
Need consistent, predictable API design that's easy to understand and use.

### Solution
Design APIs around resources (nouns) with standard HTTP verbs for operations.

### Structure
```
GET    /api/users          # List users
GET    /api/users/:id      # Get specific user
POST   /api/users          # Create user
PUT    /api/users/:id      # Update user
PATCH  /api/users/:id      # Partial update
DELETE /api/users/:id      # Delete user
```

### Response Format
```json
{
  "data": { ... },
  "meta": {
    "timestamp": "2025-01-31T12:00:00Z",
    "version": "1.0"
  },
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100
  }
}
```

### Error Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input provided",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

### Benefits
- Predictable interface
- Easy to understand
- Standard tooling support
- Clear resource relationships

---

## Pattern: API Versioning

### Context
APIs need to evolve without breaking existing clients.

### Solution
Version APIs explicitly with clear deprecation policies.

### Strategies

#### URL Versioning
```
/api/v1/users
/api/v2/users
```

#### Header Versioning
```
Accept: application/vnd.api+json;version=2
```

#### Query Parameter
```
/api/users?version=2
```

### Best Practices
- Start with v1, not v0
- Support at least N-1 versions
- Document breaking changes
- Provide migration guides
- Set deprecation timelines

---

## Pattern: Rate Limiting

### Context
Protect APIs from abuse and ensure fair usage.

### Solution
Implement rate limiting with clear communication to clients.

### Headers
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1620000000
```

### Response on Limit
```
HTTP/1.1 429 Too Many Requests
Retry-After: 3600

{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded. Try again in 3600 seconds."
  }
}
```

### Strategies
- Per-user limits
- Per-IP limits
- Per-endpoint limits
- Tier-based limits

---

## Pattern: Bulk Operations

### Context
Clients need to perform operations on multiple resources efficiently.

### Solution
Provide bulk endpoints with transaction semantics.

### Implementation
```
POST /api/users/bulk
{
  "operations": [
    { "method": "create", "data": { ... } },
    { "method": "update", "id": "123", "data": { ... } },
    { "method": "delete", "id": "456" }
  ]
}
```

### Response
```json
{
  "results": [
    { "status": "success", "id": "789", "data": { ... } },
    { "status": "success", "id": "123" },
    { "status": "error", "id": "456", "error": { ... } }
  ],
  "summary": {
    "total": 3,
    "success": 2,
    "failed": 1
  }
}
```

---

*Patterns discovered and refined through actual usage*