# Error Handling Patterns

> Category: Implementation
> Agent: Developer
> Last Updated: 2025-01-31

## Pattern: Error Boundary

### Context
React applications need graceful error handling to prevent entire app crashes.

### Solution
Implement error boundaries to catch and handle component errors.

### Implementation
```typescript
class ErrorBoundary extends React.Component<Props, State> {
  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
    // Log to error reporting service
    logErrorToService(error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <ErrorFallback
          error={this.state.error}
          resetError={() => this.setState({ hasError: false })}
        />
      );
    }

    return this.props.children;
  }
}
```

### Usage
```jsx
<ErrorBoundary>
  <App />
</ErrorBoundary>
```

---

## Pattern: Result Type

### Context
Functions can fail in predictable ways and we need type-safe error handling.

### Solution
Use a Result type to explicitly handle success and failure cases.

### Implementation
```typescript
type Result<T, E = Error> = 
  | { ok: true; value: T }
  | { ok: false; error: E };

async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const user = await api.get(`/users/${id}`);
    return { ok: true, value: user };
  } catch (error) {
    return { ok: false, error };
  }
}

// Usage
const result = await fetchUser('123');
if (result.ok) {
  console.log(result.value);
} else {
  console.error(result.error);
}
```

---

## Pattern: Retry with Exponential Backoff

### Context
Transient failures in network requests or external services.

### Solution
Implement automatic retry with exponential backoff.

### Implementation
```typescript
async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  options: {
    maxRetries?: number;
    initialDelay?: number;
    maxDelay?: number;
    factor?: number;
  } = {}
): Promise<T> {
  const {
    maxRetries = 3,
    initialDelay = 1000,
    maxDelay = 30000,
    factor = 2
  } = options;

  let delay = initialDelay;
  
  for (let i = 0; i <= maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxRetries) throw error;
      
      await new Promise(resolve => setTimeout(resolve, delay));
      delay = Math.min(delay * factor, maxDelay);
    }
  }
  
  throw new Error('Unreachable');
}
```

---

## Pattern: Error Context

### Context
Errors need additional context for debugging and user communication.

### Solution
Create custom error classes with context.

### Implementation
```typescript
class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode?: number,
    public context?: Record<string, any>
  ) {
    super(message);
    this.name = 'AppError';
  }

  toJSON() {
    return {
      name: this.name,
      message: this.message,
      code: this.code,
      statusCode: this.statusCode,
      context: this.context
    };
  }
}

// Usage
throw new AppError(
  'User not found',
  'USER_NOT_FOUND',
  404,
  { userId: id }
);
```

---

## Pattern: Global Error Handler

### Context
Centralized error handling for consistency.

### Solution
Implement a global error handler for your application.

### Implementation
```typescript
class ErrorHandler {
  private handlers = new Map<string, ErrorHandlerFn>();

  register(code: string, handler: ErrorHandlerFn) {
    this.handlers.set(code, handler);
  }

  async handle(error: AppError): Promise<void> {
    const handler = this.handlers.get(error.code);
    
    if (handler) {
      await handler(error);
    } else {
      await this.defaultHandler(error);
    }
  }

  private async defaultHandler(error: AppError) {
    console.error('Unhandled error:', error);
    // Log to service
    // Show user notification
  }
}

// Usage
errorHandler.register('NETWORK_ERROR', async (error) => {
  showToast('Network error. Please check your connection.');
});
```

---

*Patterns discovered and refined through actual usage*